require 'rails_helper'

describe Api::UsersController, type: :controller do
  before { @request.env["HTTP_AUTHORIZATION"] = api_client.token }
  let(:api_client) { create :api_client }
  let(:user_json) do
    {first_name: 'foo',
     last_name: 'bar',
     email: 'foo@bar.com',
     permissions: {student: 'test/bar'}
    }
  end
  let(:owner_json) do
    {first_name: 'foo',
     last_name: 'bar',
     email: 'foo@bar.com',
     permissions: {owner: '*'}
    }
  end
  context 'post' do
    before { post :create, params: { user: user_json }}

    it { expect(response.status).to eq 200 }
    it { expect(User.count).to eq 2 }
    it { expect(User.last.permissions.student? 'test/_').to be true }
    it { expect(User.last.uid).to eq 'foo@bar.com' }
  end

  context 'post without permissions' do
    before { post :create, params: { user: owner_json }}

    it { expect(response.status).to eq 403 }
  end

  context 'put' do
    before { User.create! user_json }
    before { put :update,  params: { id: 'foo@bar.com', user: {first_name: 'Fede'}}}

    it { expect(response.status).to eq 200 }
    it { expect(User.last.first_name).to eq('Fede') }
    it { expect(User.last.uid).to eq 'foo@bar.com' }
  end

end
