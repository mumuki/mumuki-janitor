require 'rails_helper'

describe Api::StudentsController, type: :controller do
  let(:student_json) {{
    first_name: 'Agustin',
    last_name: 'Pina',
    email: 'agus@mumuki.org',
    uid: 'agus@mumuki.org'
  }}

  let!(:organization) { create :organization, name: 'academy' }
  let!(:course) { create :course }

  context 'post' do
    let(:params) {{ student: student_json, organization: 'academy', course: 'example' }}

    context 'when user does not exist' do

      before { post :create, params: params}

      it { expect(response.status).to eq 200 }
      it { expect(User.count).to eq 1 }
      it { expect(User.first.last_name).to eq'Pina' }
      it { expect(User.first.first_name).to eq 'Agustin' }
      it { expect(User.first.uid).to eq 'agus@mumuki.org' }
      it { expect(User.first.email).to eq 'agus@mumuki.org' }
      it { expect(User.first.permissions.student? 'academy/example').to be true }

    end
    context 'when user exist' do
      context 'and have no permissions' do
        before { create :user, student_json }
        before { post :create, params: params}
        it { expect(response.status).to eq 200 }
        it { expect(User.count).to eq 1 }
        it { expect(User.first.permissions.student? 'academy/example').to be true }
      end
      context 'and have permissions' do
        before { create :user, student_json.merge(permissions: { student: 'foo/bar' }) }
        before { post :create, params: params}
        it { expect(response.status).to eq 200 }
        it { expect(User.count).to eq 1 }
        it { expect(User.first.permissions.student? 'academy/example').to be true }
        it { expect(User.first.permissions.student? 'foo/bar').to be true }
      end


    end
  end
end
