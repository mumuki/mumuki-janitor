require 'rails_helper'

describe Api::UsersController, type: :controller do
  let(:user_json) do
    {first_name: 'foo',
     last_name: 'bar',
     email: 'foo@bar.com',
     permissions: {student: 'foo/*'}
    }
  end
  context 'post' do
    before { post :create, { user: user_json }.to_json}

    it { expect(response.status).to eq 200 }
    it { expect(User.count).to eq 1 }
    it { expect(User.first.permissions).to eq('student' => 'foo/*') }
  end

  context 'put' do
    before { post :create, { user: user_json }.to_json}
    before { put :update, { user: {email: 'foo@bar.com', first_name: 'Fede'} }.to_json}

    it { expect(User.first.first_name).to eq('Fede') }
  end

end
