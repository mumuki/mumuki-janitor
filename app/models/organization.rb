class Organization < ApplicationRecord
  INDEXED_ATTRIBUTES = {
      against: [:name, :description]
  }

  serialize :profile, Mumukit::Platform::Organization::Profile
  serialize :settings, Mumukit::Platform::Organization::Settings
  serialize :theme, Mumukit::Platform::Organization::Theme

  validates :name, uniqueness: true, format: {with: /\A[-A-Za-z0-9_]*\z/}
  validates_presence_of :name, :contact_email, :locale
  validates :books, at_least_one: true
  validates :locale, inclusion: {in: Locale.all}
  before_save :set_default_values!

  include Mumukit::Platform::Organization::Helpers
  include WithSass
  include WithStaticAssets
  include WithSearch

  def update_and_notify!(attributes)
    set_nil_params! attributes
    update! attributes
    notify_updated!
  end

  def save_and_notify!
    save!
    notify_created!
  end

  def notify_created!
    notify! 'Created'
  end

  def notify_updated!
    notify! 'Changed'
    notify_all_updated! if base?
  end

  def base?
    name == Rails.configuration.base_organization_name
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

  def as_json(_options={})
    json = base? ? super : super.defaults(self.class.base_defaults)
    sanitize_json json
  end

  def self.accessible_as(user, role)
    all.select { |it| it.public? || user.has_permission?(role, it.slug) }
  end

  def self.base
    find_by name: Rails.configuration.base_organization_name
  end

  def self.base_defaults
    defaults = base
    {
        logo_url: defaults&.logo_url,
        community_link: defaults&.community_link,
        raise_hand_enabled: defaults&.raise_hand_enabled,
        theme_stylesheet: defaults&.theme_stylesheet,
        extension_javascript: defaults&.extension_javascript,
        theme_stylesheet_url: defaults&.theme_stylesheet_url,
        extension_javascript_url: defaults&.extension_javascript_url,
        terms_of_service: defaults&.terms_of_service
    }.stringify_keys
  end

  private

  def notify!(event)
    Mumukit::Nuntius.notify_event! "Organization#{event}",
                                   organization: as_json
                                                     .except('local', 'theme_stylesheet', 'extension_javascript')
                                                     .merge('locale' => simple_locale)
  end

  def absolute_url
     path
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

  def sanitize_json(hash)
    hash.except('id', 'created_at', 'updated_at')
        .merge!('theme_stylesheet_url' => Mumukit::Platform.url_for(hash['theme_stylesheet_url']),
                'extension_javascript_url' => Mumukit::Platform.url_for(hash['extension_javascript_url']))
  end
end
