require 'spec_helper'

describe Organization do
  let(:valid_data) { {
      name: 'a-name',
      contact_email: 'a@a.com',
      locale: 'es-AR',
      books: ['a-book']
  } }

  context 'is valid when all is ok' do
    let(:organization) { Organization.new(valid_data) }
    it { expect(organization.valid?).to be true }
  end

  context 'is invalid when there are no books' do
    let(:organization) { Organization.new(valid_data.merge(books: [])) }
    it { expect(organization.valid?).to be false }
  end

  context 'is invalid when the name isnt a valid slug' do
    let(:organization) { Organization.new(valid_data.merge(name: "A random name")) }
    it { expect(organization.valid?).to be false }
  end

  context 'is invalid when the locale isnt known' do
    let(:organization) { Organization.new(valid_data.merge(locale: "uk-DA")) }
    it { expect(organization.valid?).to be false }
  end
end
