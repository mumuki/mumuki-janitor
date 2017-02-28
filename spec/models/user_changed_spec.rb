require 'spec_helper'

describe 'UserChanged' do
  let(:user_json) { {
      uid: 'foo@bar.com',
      first_name: 'Foo',
      last_name: 'Bar',
      permissions: {student: 'test/example'}
  } }
  before { User.import_from_json! user_json }
  it { expect(User.first.uid).to eq 'foo@bar.com' }
  it { expect(User.first.first_name).to eq 'Foo' }
  it { expect(User.first.last_name).to eq 'Bar' }
  it { expect(User.first.permissions.student? 'test/example').to be true }
end
