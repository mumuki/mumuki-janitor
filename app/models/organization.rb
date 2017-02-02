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
    notify! 'Updated'
  end

  def slug
    Mumukit::Auth::Slug.join name
  end

  def base?
    name == 'base'
  end

  def private?
    !public?
  end

  def public?
    public
  end

  def notify!(event)
    Mumukit::Nuntius.notify_event! "Organization#{event}", organization: as_dto
  end

  def to_param
    name
  end

  def has_login_method?(login_method)
    self.login_methods.include? login_method
  end

  def as_dto
    return without_protected_fields as_json if base?

    defaults = self.class.base
    without_protected_fields as_json.defaults({
        logo_url: defaults&.logo_url,
        theme_stylesheet: defaults&.theme_stylesheet,
        extension_javascript: defaults&.extension_javascript,
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
