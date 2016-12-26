class User < ApplicationRecord

  include WithPermissions

  has_many :api_clients

  before_validation :set_uid
  after_save :notify!, :set_permissions!

  validates_presence_of :first_name, :last_name, :uid

  private

  def set_uid
    self.uid ||= email
  end

  def notify!
    NotificationMode.notify_event! 'UserChanged', user: self.as_json
  end

end
