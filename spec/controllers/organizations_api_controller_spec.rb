require 'rails_helper'

describe Api::OrganizationsController, type: :controller do

  context 'GET' do
    let!(:public_organization) { create :organization, name: 'public' }
    let!(:private_organization) { create :organization, name: 'test', private: true }

    context 'GET /organizations' do
      before { get :index }
      let!(:body) { JSON.parse(response.body, symbolize_names: true) }

      it { expect(response.status).to eq 200 }
      it { expect(body.map { |it| it[:name] }).to eq ['public'] }
      it { expect(body.first.keys).to include(*[:id, :name, :contact_email, :books, :locale, :login_methods, :private, :created_at, :updated_at]) }
    end
  end

end
