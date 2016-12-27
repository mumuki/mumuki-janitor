require 'spec_helper'

describe Office::Event::UserChanged do
  let(:user_json) {
    { user: {
        uid: 'foo@bar.com',
        first_name: 'Foo',
        last_name: 'Bar',
        permissions: {student: 'test/example'}
    }}
  }
  before { Office::Event::UserChanged.execute! user_json }
  it {expect(User.first.uid).to eq 'foo@bar.com'}
  it {expect(User.first.first_name).to eq 'Foo'}
  it {expect(User.first.last_name).to eq 'Bar'}
  it {expect(User.first.permissions.student? 'test/example').to be true}
end
