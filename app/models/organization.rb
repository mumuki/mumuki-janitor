class Organization < ApplicationRecord
  validates :name, :uniqueness => true, :format => { :with => /\A[-a-z0-9_]*\z/ }
  validates_presence_of :name, :contact_email, :locale
  validates :books, :at_least_one => true
  validates :login_methods, :at_least_one => true
  validates :locale, :inclusion => { :in => %w(es-AR en-US) }

  def slug
    Mumukit::Auth::Slug.join self.name
  end

  def notify!
    Mumukit::Nuntius.notify_event!({organization: as_json}, 'OrganizationCreated')
  end
end
