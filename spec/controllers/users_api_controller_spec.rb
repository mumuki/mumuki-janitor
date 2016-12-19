require 'rails_helper'

describe Api::UsersController, type: :controller do
  let(:user_json) do
    {first_name: 'foo',
     last_name: 'bar',
     email: 'foo@bar.com',
     permissions: {student: 'foo/_'}
    }
  end
  context 'post' do
    before { post :create, params: { user: user_json }}

    it { expect(response.status).to eq 200 }
    it { expect(User.count).to eq 1 }
    it { expect(User.first.permissions.student? 'foo/_').to be true }
    it { expect(User.first.uid).to eq 'foo@bar.com' }
  end

  context 'put' do
    before { User.create! user_json }
    before { put :update,  params: { id: 'foo@bar.com', user: {first_name: 'Fede'}}}

    it { expect(response.status).to eq 200 }
    it { expect(User.first.first_name).to eq('Fede') }
    it { expect(User.first.uid).to eq 'foo@bar.com' }
  end

end
