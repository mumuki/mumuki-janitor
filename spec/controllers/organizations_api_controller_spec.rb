require 'rails_helper'

describe Api::OrganizationsController, type: :controller do
  def check_status!(status)
    expect(response.status).to eq status
  end

  def check_fields_presence!(response)
    body = Array.wrap(response.body.parse_as_json)
    expect(body.first.keys).to include *[:id, :name, :contact_email, :books, :locale, :login_methods, :private, :logo_url, :created_at, :updated_at]
  end

  context 'GET' do
    let!(:public_organization) { create :organization, name: 'public' }
    let!(:private_organization) { create :organization, name: 'private', private: true }

    context 'GET /organizations' do
      before { get :index }
      let!(:body) { response.body.parse_as_json }

      it { check_status! 200 }
      it { check_fields_presence! response }
      it { expect(body.map { |it| it[:name] }).to eq %w(public) }
    end

    context 'GET /organizations/:id' do
      before { set_api_client }

      context 'with a public organization' do
        before { get :show, params: { id: 'public' } }

        context 'with a user without permissions' do
          let(:api_client) { create :api_client, role: :editor, grant: 'another_organization/*' }

          it { check_status! 200 }
        end
      end

      context 'with a private organization' do
        before { get :show, params: { id: 'private' } }

        context 'with a user without permissions' do
          let(:api_client) { create :api_client, role: :editor, grant: 'another_organization/*' }

          it { check_status! 403 }
        end

        context 'with a user with permissions' do
          let(:api_client) { create :api_client, role: :janitor, grant: 'private/*' }

          it { check_status! 200 }
          it { check_fields_presence! response }
        end
      end
    end
  end

  context 'POST /organizations' do
    before { set_api_client }
    before { post :create, params: organization_json }
    let(:organization_json) do
      {contact_email: 'an_email@gmail.com',
       name: 'a-name',
       books: %w(a-book),
       login_methods: ['facebook', 'github'],
       locale: 'es-AR'}
    end

    context 'with the god permissions' do
      let(:api_client) { create :api_client, role: :owner, grant: '*' }

      it { check_status! 200 }
      it { check_fields_presence! response }
      it { expect(Organization.count).to eq 1 }
      it { expect(Organization.first.name).to eq "a-name" }
      it { expect(Organization.first.contact_email).to eq "an_email@gmail.com" }
      it { expect(Organization.first.books).to eq %w(a-book) }
      it { expect(Organization.first.login_methods).to eq %w(facebook github) }
      it { expect(Organization.first.locale).to eq 'es-AR' }

      context 'with only mandatory values' do
        it { expect(Organization.first.private).to eq false }
        it { expect(Organization.first.logo_url).to eq 'http://mumuki.io/logo-alt-large.png' }
      end

      context 'with optional values' do
        let(:organization_json) do
          {contact_email: 'an_email@gmail.com',
           name: 'a-name',
           books: %w(a-book),
           login_methods: ['facebook', 'github'],
           locale: 'es-AR',
           private: true,
           logo_url: 'http://a-logo-url.com',
           theme_stylesheet: '.theme { color: red }',
           terms_of_service: 'A TOS'}
        end

        it { expect(Organization.first.private).to eq true }
        it { expect(Organization.first.logo_url).to eq 'http://a-logo-url.com' }
        it { expect(Organization.first.theme_stylesheet).to eq '.theme { color: red }' }
        it { expect(Organization.first.terms_of_service).to eq 'A TOS' }
      end

      context 'with missing values' do
        let(:organization_json) do
          {contact_email: 'an_email@gmail.com',
           books: %w(),
           locale: 'blabla',
           login_methods: ['facebook', 'github']}
        end
        let(:expected_errors) do
          {
              errors: {
                  name: [ "can't be blank" ],
                  locale: [ 'is not included in the list' ],
                  books: [ 'has no elements' ]
              }
          }
        end

        it { check_status! 400 }
        it { expect(response.body.parse_as_json).to eq expected_errors}
      end
    end

    context 'with not-owner permissions' do
      let(:api_client) { create :api_client, role: :janitor, grant: '*' }

      it { check_status! 403 }
    end
  end

  context 'PUT /organizations/:id' do
    before { set_api_client }
    let!(:public_organization) { create :organization, name: 'existing-organization', contact_email: "first_email@gmail.com" }
    let(:update_json) { { id: 'existing-organization', contact_email: 'second_email@gmail.com' } }

    context 'with the owner permissions' do
      let(:api_client) { create :api_client, role: :owner, grant: 'existing-organization/*' }
      before { put :update, params: update_json }

      it { check_status! 200 }
      it { check_fields_presence! response }
      it { expect(Organization.first.name).to eq "existing-organization" }
      it { expect(Organization.first.contact_email).to eq "second_email@gmail.com" }
    end

    context 'with not-owner permissions' do
      let(:api_client) { create :api_client, role: :janitor, grant: 'existing-organization/*' }
      before { put :update, params: update_json }

      it { check_status! 403 }
    end
  end

end
