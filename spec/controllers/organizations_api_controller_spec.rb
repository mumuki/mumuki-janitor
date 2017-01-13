require 'rails_helper'

describe Api::OrganizationsController, type: :controller do

  context 'GET' do
    let!(:public_organization) { create :organization, id: 1, name: 'public' }
    let!(:private_organization) { create :organization, id: 2, name: 'private', private: true }

    def check_status!(status)
      expect(response.status).to eq status
    end

    def check_fields_presence!(response)
      body = Array.wrap(response.body.parse_as_json)
      expect(body.first.keys).to include *[:id, :name, :contact_email, :books, :locale, :login_methods, :private, :created_at, :updated_at]
    end

    context 'GET /organizations' do
      before { get :index }
      let!(:body) { response.body.parse_as_json }

      it { check_status! 200 }
      it { check_fields_presence! response }
      it { expect(body.map { |it| it[:name] }).to eq ['public'] }
    end

    context 'GET /organizations/:id' do
      before { set_api_client }

      context 'with a public organization' do
        before { get :show, params: { id: 1 } }

        context 'with a user without permissions' do
          let(:api_client) { create :api_client, role: :editor, grant: 'another_organization/*' }

          it { check_status! 200 }
        end
      end

      context 'with a private organization' do
        before { get :show, params: { id: 2 } }

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

end
