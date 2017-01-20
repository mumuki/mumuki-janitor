class Organization < ApplicationRecord
  validates :name, uniqueness: true, format: { with: /\A[-a-z0-9_]*\z/ }
  validates_presence_of :name, :contact_email, :locale
  validates :books, at_least_one: true
  validates :locale, inclusion: { in: %w(es-AR en-US) }
  before_save :set_default_values!

  def slug
    Mumukit::Auth::Slug.join name
  end

  def notify!
    Mumukit::Nuntius.notify_event!({organization: as_json}, 'OrganizationCreated')
  end

  def private?
    !public?
  end

  def public?
    public
  end

  def self.accessible_as(permissions, role)
    all.select { |it| it.public? || permissions.has_permission?(role, it.slug) }
  end

  def set_default_values!
    self.public ||= false
    self.login_methods ||= []
    self.logo_url ||= 'http://mumuki.io/logo-alt-large.png'
    self.theme_stylesheet ||= ''

    self.login_methods.push 'user_pass' if self.login_methods.empty?
  end
end
