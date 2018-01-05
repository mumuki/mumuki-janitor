require 'spec_helper'

describe Organization do
  def data(name)
    {
      name: name,
      contact_email: 'a@a.com',
      locale: 'es-AR',
      books: ['a-book']
    }
  end

  let(:valid_data) { data 'a-name' }

  let(:valid_data_2) { data 'a.name'}

  let(:valid_data_3) { data 'a.name.with.subdomains'}

  let(:invalid_data) { data '.a.name.that.starts.with.period'}

  let(:invalid_data_2) { data 'a.name.that.ends.with.period.'}

  let(:invalid_data_3) { data 'a.name.that..has.two.periods.in.a.row'}

  let(:invalid_data_4) { data 'a.name.with.Uppercases'}

  describe 'notifications' do
    context '#notify_created!' do
      let!(:organization) { create(:organization, name: 'pdep') }
      before {
        expect_any_instance_of(Mumukit::Nuntius::NotificationMode::Deaf).to(
            receive(:notify_event!).with(
                'OrganizationCreated', {
                organization: {
                    logo_url: 'MyString',
                    community_link: nil,
                    theme_stylesheet_url: 'http://office.localmumuki.io/stylesheets/pdep-da39a3ee5e6b4b0d3255bfef95601890afd80709.css',
                    extension_javascript_url: 'http://office.localmumuki.io/javascripts/pdep-da39a3ee5e6b4b0d3255bfef95601890afd80709.js',
                    terms_of_service: nil,
                    name: 'pdep',
                    description: 'MyText',
                    public: true,
                    contact_email: 'MyString',
                    books: ['MyString'],
                    locale: 'es',
                    login_methods: ['MyString'],
                    raise_hand_enabled: false
                }.deep_stringify_keys
            }
            )
        )
      }

      it { organization.notify_created! }
    end
  end

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

  context 'has login method' do
    let(:organization) { Organization.new(valid_data.merge(login_methods: ['github'])) }
    it { expect(organization.has_login_method? 'github').to be true }
    it { expect(organization.has_login_method? 'google').to be false }
  end

  context 'organization name' do
    it { expect(Organization.new(valid_data).valid?).to be true }
    it { expect(Organization.new(valid_data_2).valid?).to be true }
    it { expect(Organization.new(valid_data_3).valid?).to be true }
    it { expect(Organization.new(invalid_data).valid?).to be false }
    it { expect(Organization.new(invalid_data_2).valid?).to be false }
    it { expect(Organization.new(invalid_data_3).valid?).to be false }
    it { expect(Organization.new(invalid_data_4).valid?).to be false }
  end

end
