class User < ApplicationRecord

  include WithPermissions
  extend WithImport

  has_many :api_clients

  before_validation :set_uid
  after_commit :set_permissions!

  validates_presence_of :first_name, :last_name, :uid

  def attach!(role, course)
    add_permission! role, course.slug
    save_and_notify!
  end

  def detach!(role, course)
    remove_permission! role, course.slug
    save_and_notify!
  end

  def notify!
    Mumukit::Nuntius.notify_event!({user: self.as_json}, 'UserChanged')
  end

  def self.create_if_necessary(user)
    user[:uid] ||= user[:email]
    User.where(uid: user[:uid]).first_or_create(user)
  end

  private

  def save_and_notify!
    save!
    notify!
  end

  def set_uid
    self.uid ||= email
  end
end
