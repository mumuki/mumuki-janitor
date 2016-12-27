class User < ApplicationRecord

  include WithPermissions

  has_many :api_clients

  before_validation :set_uid
  after_commit :set_permissions!

  validates_presence_of :first_name, :last_name, :uid

  def self.import_from_json!(user_data)
    User.where(uid: user_data[:uid]).update_or_create(user_data).save!
  end

  def notify!
    NotificationMode.notify_event! 'UserChanged', user: self.as_json
  end

  private

  def set_uid
    self.uid ||= email
  end
end
