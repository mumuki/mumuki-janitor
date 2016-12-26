require 'rails_helper'

describe ApiClientsController, type: :controller do
  before { @request.env["HTTP_AUTHORIZATION"] = api_client.token }
  let(:api_client) { create :api_client }
  let(:api_client_json) do
    {description: 'foo',
     user_attributes: user_json
    }
  end
  let(:user_json) do
    {first_name: 'foo',
     last_name: 'bar',
     email: 'foo@bar.com',
     permissions: {student: 'foo/*'}
    }
  end
  context 'post' do
    before { post :create, params: { api_client: api_client_json }}

    it { expect(response.status).to eq 200 }
    it { expect(ApiClient.count).to eq 1 }
    it { expect(ApiClient.first.user.permissions).to eq('student' => 'foo/*') }
    it { expect(Apiclient.first.user.email).to eq 'foo@bar.com' }
  end
end
