class User < ApplicationRecord
  INDEXED_ATTRIBUTES = {
      against: [:first_name, :last_name, :email, :social_id]
  }

  include WithPermissions, WithSearch
  extend WithImport

  has_many :api_clients

  after_initialize :init
  before_validation :set_uid

  validates_presence_of :uid

  def attach!(role, course)
    add_permission! role, course.slug
    save_and_notify!
  end

  def detach!(role, course)
    remove_permission! role, course.slug
    save_and_notify!
  end

  def notify!
    Mumukit::Nuntius.notify_event! 'UserChanged', user: self.as_json(except: [:id])
  end

  def self.create_if_necessary(user)
    user[:uid] ||= user[:email]
    User.where(uid: user[:uid]).first_or_create(user)
  end

  def to_s
    "#{name} <#{email}>"
  end

  def to_param
    uid
  end

  def name
    "#{first_name} #{last_name}"
  end

  def self.for_profile(profile)
    where(uid: profile.uid).first_or_initialize.tap do |user|
      user.update! profile.to_h.except(:provider, :name)
    end
  end

  private

  def init
    self.image_url ||= 'user_shape.png'
  end

  def save_and_notify!
    save!
    notify!
  end

  def set_uid
    self.uid ||= email
  end
end
