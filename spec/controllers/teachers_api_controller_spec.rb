require 'rails_helper'

describe Api::TeachersController, type: :controller do
  before { set_api_client }
  let(:api_client) { create :api_client }
  let(:teacher_json) { {
      first_name: 'Agustin',
      last_name: 'Pina',
      email: 'agus@mumuki.org',
      uid: 'agus@mumuki.org'
  } }

  let!(:organization) { create :organization, name: 'test' }
  let!(:course) { create :course }

  context 'post' do
    let(:params) { {teacher: teacher_json, organization: 'test', course: 'example'} }

    context 'when user does not exist' do

      before { post :create, params: params }

      it { expect(response.status).to eq 200 }
      it { expect(User.count).to eq 2 }
      it { expect(User.last.last_name).to eq 'Pina' }
      it { expect(User.last.first_name).to eq 'Agustin' }
      it { expect(User.last.uid).to eq 'agus@mumuki.org' }
      it { expect(User.last.email).to eq 'agus@mumuki.org' }
      it { expect(User.last.permissions.teacher? 'test/example').to be true }

    end
    context 'when user exist' do
      context 'and have no permissions' do
        before { create :user, teacher_json }
        before { post :create, params: params }
        it { expect(response.status).to eq 200 }
        it { expect(User.count).to eq 2 }
        it { expect(User.last.permissions.teacher? 'test/example').to be true }
      end
      context 'and have permissions' do
        before { create :user, teacher_json.merge(permissions: {teacher: 'foo/bar'}) }
        before { post :create, params: params }
        it { expect(response.status).to eq 200 }
        it { expect(User.count).to eq 2 }
        it { expect(User.last.permissions.teacher? 'test/example').to be true }
        it { expect(User.last.permissions.teacher? 'foo/bar').to be true }
      end


    end
  end

  context 'attach teacher' do
    let(:params) { {uid: teacher_json[:uid], organization: 'test', course: 'example'} }

    context 'when user does not exist' do
      before { post :attach, params: params }
      it { expect(response.status).to eq 404 }
    end

    context 'when user exist' do
      context 'and have no permissions' do
        before { create :user, teacher_json }
        before { post :attach, params: params }
        it { expect(response.status).to eq 200 }
        it { expect(User.last.permissions.teacher? 'test/example').to be true }
      end
      context 'and have permissions' do
        before { create :user, teacher_json.merge(permissions: {teacher: 'foo/bar'}) }
        before { post :attach, params: params }
        it { expect(response.status).to eq 200 }
        it { expect(User.last.permissions.teacher? 'test/example').to be true }
        it { expect(User.last.permissions.teacher? 'foo/bar').to be true }
      end
    end

  end

  context 'detach teacher' do
    let(:params) { {uid: teacher_json[:uid], organization: 'test', course: 'example'} }

    context 'when user does not exist' do
      before { post :detach, params: params }
      it { expect(response.status).to eq 404 }
    end

    context 'when user exist' do
      context 'and have permissions' do
        before { create :user, teacher_json.merge(permissions: {teacher: 'test/example'}) }
        before { post :detach, params: params }
        it { expect(response.status).to eq 200 }
        it { expect(User.last.permissions.teacher? 'test/example').to be false }
      end
    end

  end
end
