require 'rails_helper'

describe Api::StudentsController, type: :controller do
  before { set_api_client }
  let(:api_client) { create :api_client }
  let(:student_json) {{
    first_name: 'Agustin',
    last_name: 'Pina',
    email: 'agus@mumuki.org',
    uid: 'agus@mumuki.org'
  }}

  let!(:organization) { create :organization, name: 'test' }
  let!(:course) { create :course }

  context 'post' do
    let(:params) {{ student: student_json, organization: 'test', course: 'example' }}

    context 'when user does not exist' do

      before { post :create, params: params}

      it { expect(response.status).to eq 200 }
      it { expect(User.count).to eq 2 }
      it { expect(User.last.last_name).to eq'Pina' }
      it { expect(User.last.first_name).to eq 'Agustin' }
      it { expect(User.last.uid).to eq 'agus@mumuki.org' }
      it { expect(User.last.email).to eq 'agus@mumuki.org' }
      it { expect(User.last.permissions.student? 'test/example').to be true }

    end
    context 'when user exist' do
      context 'and have no permissions' do
        before { create :user, student_json }
        before { post :create, params: params}
        it { expect(response.status).to eq 200 }
        it { expect(User.count).to eq 2 }
        it { expect(User.last.permissions.student? 'test/example').to be true }
      end
      context 'and have permissions' do
        before { create :user, student_json.merge(permissions: { student: 'foo/bar' }) }
        before { post :create, params: params}
        it { expect(response.status).to eq 200 }
        it { expect(User.count).to eq 2 }
        it { expect(User.last.permissions.student? 'test/example').to be true }
        it { expect(User.last.permissions.student? 'foo/bar').to be true }
      end


    end
  end

  context 'attach student' do
    let(:params) {{ uid: student_json[:uid], organization: 'test', course: 'example' }}

    context 'when user does not exist' do
      before { post :attach, params: params}
      it { expect(response.status).to eq 404 }
    end

    context 'when user exist' do
      context 'and have no permissions' do
        before { create :user, student_json }
        before { post :attach, params: params}
        it { expect(response.status).to eq 200 }
        it { expect(User.last.permissions.student? 'test/example').to be true }
      end
      context 'and have permissions' do
        before { create :user, student_json.merge(permissions: { student: 'foo/bar' }) }
        before { post :attach, params: params}
        it { expect(response.status).to eq 200 }
        it { expect(User.last.permissions.student? 'test/example').to be true }
        it { expect(User.last.permissions.student? 'foo/bar').to be true }
      end
    end

  end

  context 'detach student' do
    let(:params) {{ uid: student_json[:uid], organization: 'test', course: 'example' }}

    context 'when user does not exist' do
      before { post :detach, params: params}
      it { expect(response.status).to eq 404 }
    end

    context 'when user exist' do
      context 'and have permissions' do
        before { create :user, student_json.merge(permissions: { student: 'test/example' }) }
        before { post :detach, params: params}
        it { expect(response.status).to eq 200 }
        it { expect(User.last.permissions.student? 'test/example').to be false }
      end
    end

  end
end
