class Organization < ApplicationRecord
  validates :name, uniqueness: true, format: { with: /\A[-a-z0-9_]*\z/ }
  validates_presence_of :name, :contact_email, :locale
  validates :books, at_least_one: true
  validates :login_methods, at_least_one: true
  validates :locale, inclusion: { in: %w(es-AR en-US) }
  before_save :default_values

  def slug
    Mumukit::Auth::Slug.join name
  end

  def notify!
    Mumukit::Nuntius.notify_event!({organization: as_json}, 'OrganizationCreated')
  end

  def default_values
    self.logo_url ||= 'http://mumuki.io/logo-alt-large.png'
  end
end
