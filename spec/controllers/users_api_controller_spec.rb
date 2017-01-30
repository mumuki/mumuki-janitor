require 'rails_helper'

describe Api::UsersController, type: :controller do
  before { set_api_client! }
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
     permissions: {owner: '*'}}
  end
  context 'post' do
    before { post :create, params: {user: user_json} }

    it { expect(response.status).to eq 200 }
    it { expect(response.body.parse_json).to json_like({first_name: 'foo',
                                                        last_name: 'bar',
                                                        email: 'foo@bar.com',
                                                        permissions: {'student' => 'test/bar'},
                                                        uid: 'foo@bar.com',
                                                        image_url: 'user_shape.png',
                                                        social_id: nil},
                                                       except: [:id, :created_at, :updated_at]) }
    it { expect(User.count).to eq 2 }
    it { expect(User.last.permissions.student? 'test/_').to be true }
    it { expect(User.last.uid).to eq 'foo@bar.com' }
  end


  context 'post without permissions' do
    before { post :create, params: {user: owner_json} }

    it { expect(response.status).to eq 403 }
  end

  context 'put' do
    before { User.create! user_json }
    before { put :update, params: {id: 'foo@bar.com', user: {first_name: 'Fede'}} }

    it { expect(response.status).to eq 200 }
    it { expect(User.last.first_name).to eq('Fede') }
    it { expect(User.last.uid).to eq 'foo@bar.com' }
  end

end
