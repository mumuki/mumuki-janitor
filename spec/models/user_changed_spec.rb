require 'spec_helper'

describe 'UserChanged' do
  before { User.import_from_json! user_json }

  shared_context 'a proper import' do
    it { expect(User.first.uid).to eq 'foo@bar.com' }
    it { expect(User.first.first_name).to eq 'Foo' }
    it { expect(User.first.last_name).to eq 'Bar' }
  end

  context 'with permissions changes' do
    let(:user_json) { {
      uid: 'foo@bar.com',
      first_name: 'Foo',
      last_name: 'Bar',
      permissions: {student: 'test/example'}
    } }

    it_behaves_like 'a proper import'
    it { expect(User.first.permissions.student? 'test/example').to be true }
  end

  context 'no permissions changed' do
    let(:user_json) { {
        uid: 'foo@bar.com',
        first_name: 'Foo',
        last_name: 'Bar'
    } }

    it_behaves_like 'a proper import'
  end
end
