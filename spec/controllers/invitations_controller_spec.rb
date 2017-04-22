require 'rails_helper'

describe Api::InvitationsController, type: :controller do
  let!(:organization) { create :organization, name: 'test' }
  let!(:api_client) { create :api_client, role: :janitor, grant: 'test/*' }
  before { set_api_client! }
  before { create :course }

  context 'POST /courses/:organization/:course/invitations' do
    before { post :create, params: { organization: 'test', course: 'example' } }
    let!(:body) { response.body.parse_json }

    it { expect(response.status).to eq 200 }
    it { expect(body[:slug]).to match /\w\w\w\w-example/ }
    it { expect(body[:expiration_date]).to eq (Date.today + 7).to_s }
    it { expect(body[:course]).to eq "test/example" }
    it { expect(body[:url]).to match /http:\/\/mumuki\.io\/join\/\w\w\w\w-example/ }
  end

  context 'GET /courses/:organization/:course/invitations' do
    before { post :create, params: { organization: 'test', course: 'example' } }

    context 'retrieves an array with the invitations' do
      before { get :index, params: { organization: 'test', course: 'example' } }
      let!(:body) { response.body.parse_json }

      it { expect(response.status).to eq 200 }
      it { expect(body[:invitations].length).to eq 1 }
    end
  end

end
