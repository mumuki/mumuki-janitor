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
    set_nil_params! attributes
    update! attributes
    notify_updated!
  end

  def notify_created!
    notify! 'Created'
  end

  def notify_updated!
    notify! 'Updated'
    notify_all_updated! if base?
  end

  def slug
    Mumukit::Auth::Slug.join name
  end

  def base?
    name == Rails.configuration.base_organization_name
  end

  def private?
    !public?
  end

  def public?
    public
  end

  def to_param
    name
  end

  def has_login_method?(login_method)
    self.login_methods.include? login_method.to_s
  end

  def as_json(options = nil)
    json = super
    return without_protected_fields json if base?

    defaults = self.class.base
    without_protected_fields json.defaults({
                                               logo_url: defaults&.logo_url,
                                               theme_stylesheet: defaults&.theme_stylesheet,
                                               extension_javascript: defaults&.extension_javascript,
                                               theme_stylesheet_url: defaults&.theme_stylesheet_url,
                                               extension_javascript_url: defaults&.extension_javascript_url,
                                               terms_of_service: defaults&.terms_of_service
                                           }.stringify_keys)
  end

  def self.accessible_as(user, role)
    all.select { |it| it.public? || user.has_permission?(role, it.slug) }
  end

  def self.base
    find_by name: Rails.configuration.base_organization_name
  end

  private

  def notify!(event)
    Mumukit::Nuntius.notify_event! "Organization#{event}", organization: as_json.except('theme_stylesheet', 'extension_javascript')
  end

  def notify_all_updated!
    Organization.all.select { |it| !it.base? }.each { |it| it.notify_updated! }
  end

  def set_default_values!
    self.public ||= false
    self.login_methods ||= []
    self.login_methods.push 'user_pass' if self.login_methods.empty?
  end

  def set_nil_params!(attributes)
    attributes.select { |k, v| v.nil? }
        .each { |k, v| update_attribute k, nil }
  end

  def without_protected_fields(hash)
    hash.except 'id', 'created_at', 'updated_at'
  end
end
