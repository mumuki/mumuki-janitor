class Organization < ApplicationRecord
  INDEXED_ATTRIBUTES = {
      against: [:name, :description]
  }
  validates :name, uniqueness: true, format: {with: /\A[-A-Za-z0-9_]*\z/}
  validates_presence_of :name, :contact_email, :locale
  validates :books, at_least_one: true
  validates :locale, inclusion: {in: Locale.all}
  before_save :set_default_values!

  include WithSass
  include WithStaticAssets
  include WithSearch

  def update_and_notify!(attributes)
    update! attributes
    notify! 'Changed'
  end

  def slug
    Mumukit::Auth::Slug.join name
  end

  def private?
    !public?
  end

  def public?
    public
  end

  def notify!(event)
    Mumukit::Nuntius.notify_event! "Organization#{event}",
                                   organization: as_json.except(
                                       'id',
                                       'theme_stylesheet',
                                       'extension_javascript',
                                       'created_at',
                                       'updated_at').
                                       merge('locale' => simple_locale)
  end

  def to_param
    name
  end

  def has_login_method?(login_method)
    self.login_methods.include? login_method.to_s
  end

  def simple_locale
    locale.split('-').first
  end

  def self.accessible_as(user, role)
    all.select { |it| it.public? || user.has_permission?(role, it.slug) }
  end

  private

  def set_default_values!
    self.public ||= false
    self.login_methods ||= []
    self.logo_url ||= 'http://mumuki.io/logo-alt-large.png'
    self.theme_stylesheet ||= ''
    self.extension_javascript ||= ''

    self.login_methods.push 'user_pass' if self.login_methods.empty?
  end
end
