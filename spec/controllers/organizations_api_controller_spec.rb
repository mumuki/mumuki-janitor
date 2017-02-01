require 'rails_helper'

describe Api::OrganizationsController, type: :controller do
  before { set_api_client! }

  def check_status!(status)
    expect(response.status).to eq status
  end

  context 'GET' do
    let!(:public_organization) { create :organization, name: 'public' }
    let!(:private_organization) { create :organization, name: 'private', public: false }
    let!(:another_private_organization) { create :organization, name: 'another_private', public: false }

    context 'GET /organizations' do
      before { get :index }
      let(:api_client) { create :api_client, role: :janitor, grant: 'private/*' }
      let!(:body) { response.body.parse_json }

      it { check_status! 200 }
      it { expect(body.length).to eq 2 }
      # FIXME Organization api should return a json
      # FIXME Organizations api should not return ids nor dates
      skip { expect(response.body.parse_json).to json_like({}) }
      it { expect(body.map { |it| it[:name] }).to eq %w(public private) }
    end

    context 'GET /organizations/:id' do
      context 'with a public organization' do
        before { get :show, params: {id: 'public'} }

        context 'with a user without janitor permissions' do
          let(:api_client) { create :api_client, role: :editor, grant: 'another_organization/*' }

          it { check_status! 403 }
        end

        context 'with a user with janitor' do
          let(:api_client) { create :api_client, role: :janitor, grant: 'public/*' }

          it { check_status! 200 }
        end
      end

      context 'with a private organization' do
        before { get :show, params: {id: 'private'} }

        context 'with a user without permissions' do
          let(:api_client) { create :api_client, role: :editor, grant: 'another_organization/*' }

          it { check_status! 403 }
        end

        context 'with a user with permissions' do
          let(:api_client) { create :api_client, role: :janitor, grant: 'private/*' }

          it { check_status! 200 }
          it { expect(response.body.parse_json).to json_like({name: 'private',
                                                              description: 'MyText',
                                                              logo_url: 'MyString',
                                                              public: false,
                                                              contact_email: 'MyString',
                                                              theme_stylesheet: '',
                                                              books: ['MyString'],
                                                              locale: 'es-AR',
                                                              terms_of_service: nil,
                                                              login_methods: ['MyString'],
                                                              theme_stylesheet_url: 'stylesheets/private-da39a3ee5e6b4b0d3255bfef95601890afd80709',
                                                              extension_javascript: '',
                                                              extension_javascript_url: 'javascripts/private-da39a3ee5e6b4b0d3255bfef95601890afd80709'},
                                                             {except: [:created_at, :updated_at, :id]}) }
        end
      end

      context 'with a non-existing organization' do
        before { get :show, params: {id: 'non-existing'} }
        let(:api_client) { create :api_client, role: :editor, grant: 'bleh/*' }

        it { check_status! 404 }
      end
    end
  end

  context 'POST /organizations' do
    before { post :create, params: {organization: organization_json} }
    let(:organization_json) do
      {contact_email: 'an_email@gmail.com',
       name: 'a-name',
       books: %w(a-book),
       locale: 'es-AR'}
    end

    context 'with the owner permissions' do
      let(:api_client) { create :api_client, role: :owner, grant: '*' }

      it { check_status! 200 }
      it { expect(response.body.parse_json).to json_like({name: 'a-name',
                                                          description: nil,
                                                          logo_url: 'http://mumuki.io/logo-alt-large.png',
                                                          public: false,
                                                          contact_email: 'an_email@gmail.com',
                                                          theme_stylesheet: '',
                                                          books: ['a-book'],
                                                          locale: 'es-AR',
                                                          terms_of_service: nil,
                                                          login_methods: ['user_pass'],
                                                          theme_stylesheet_url: 'stylesheets/a-name-da39a3ee5e6b4b0d3255bfef95601890afd80709',
                                                          extension_javascript: '',
                                                          extension_javascript_url: 'javascripts/a-name-da39a3ee5e6b4b0d3255bfef95601890afd80709'},
                                                         {except: [:created_at, :updated_at, :id]}) }
      it { expect(Organization.count).to eq 1 }
      it { expect(Organization.first.name).to eq "a-name" }
      it { expect(Organization.first.contact_email).to eq "an_email@gmail.com" }
      it { expect(Organization.first.books).to eq %w(a-book) }
      it { expect(Organization.first.locale).to eq 'es-AR' }

      context 'with only mandatory values' do
        it { expect(Organization.first.public?).to eq false }
        it { expect(Organization.first.login_methods).to eq %w(user_pass) }
        it { expect(Organization.first.logo_url).to eq 'http://mumuki.io/logo-alt-large.png' }
        it { expect(Organization.first.theme_stylesheet).to eq '' }
        it { expect(Organization.first.terms_of_service).to eq '' }
      end

      context 'with optional values' do
        let(:organization_json) do
          {contact_email: 'an_email@gmail.com',
           name: 'a-name',
           description: 'A description',
           books: %w(a-book),
           locale: 'es-AR',
           public: true,
           login_methods: %w(facebook github),
           logo_url: 'http://a-logo-url.com',
           theme_stylesheet: '.theme { color: red }',
           extension_javascript: 'window.a = function() { }',
           terms_of_service: 'A TOS'}
        end

        it { expect(Organization.first.public?).to eq true }
        it { expect(Organization.first.description).to eq 'A description' }
        it { expect(Organization.first.login_methods).to eq %w(facebook github) }
        it { expect(Organization.first.logo_url).to eq 'http://a-logo-url.com' }
        it { expect(Organization.first.theme_stylesheet).to eq ".theme { color: red }" }
        it { expect(Organization.first.extension_javascript).to eq "window.a = function() { }" }
        it { expect(Organization.first.terms_of_service).to eq 'A TOS' }
      end

      context 'with missing values' do
        let(:organization_json) do
          {contact_email: 'an_email@gmail.com',
           books: %w(),
           locale: 'blabla'}
        end
        let(:expected_errors) do
          {
              errors: {
                  name: ["can't be blank"],
                  locale: ['is not included in the list'],
                  books: ['has no elements']
              }
          }
        end

        it { check_status! 400 }
        it { expect(response.body.parse_json).to eq expected_errors }
      end
    end

    context 'with owner permissions' do
      let(:api_client) { create :api_client, role: :owner, grant: '*' }

      it { check_status! 200 }
    end


    context 'with not-janitor permissions' do
      let(:api_client) { create :api_client, role: :editor, grant: '*' }

      it { check_status! 403 }
    end
  end

  context 'PUT /organizations/:id' do
    let!(:public_organization) { create :organization, name: 'existing-organization', contact_email: "first_email@gmail.com" }
    let(:update_json) { {contact_email: 'second_email@gmail.com'} }

    context 'with the owner permissions' do
      let(:api_client) { create :api_client, role: :owner, grant: 'existing-organization/*' }
      before { put :update, params: {id: 'existing-organization', organization: update_json} }

      it { check_status! 200 }
      it { expect(response.body.parse_json).to json_like({name: 'existing-organization',
                                                          contact_email: 'second_email@gmail.com',
                                                          locale: 'es-AR',
                                                          books: ['MyString'],
                                                          public: true,
                                                          login_methods: ['MyString'],
                                                          logo_url: 'MyString',
                                                          theme_stylesheet: '',
                                                          extension_javascript: '',
                                                          theme_stylesheet_url: 'stylesheets/existing-organization-da39a3ee5e6b4b0d3255bfef95601890afd80709',
                                                          extension_javascript_url: 'javascripts/existing-organization-da39a3ee5e6b4b0d3255bfef95601890afd80709',
                                                          description: 'MyText',
                                                          terms_of_service: nil},
                                                         except: [:created_at, :updated_at, :id]) }
      it { expect(Organization.first.name).to eq "existing-organization" }
      it { expect(Organization.first.contact_email).to eq "second_email@gmail.com" }
    end

    context 'with not-janitor permissions' do
      let(:api_client) { create :api_client, role: :teacher, grant: 'existing-organization/*' }
      before { put :update, params: {id: 'existing-organization', organization: update_json} }

      it { check_status! 403 }
    end
  end

end
