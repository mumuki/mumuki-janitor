class User < ApplicationRecord

  include WithPermissions

  validates_presence_of :first_name, :last_name, :email, :uid
  before_validation :set_uid
  after_save :notify!
  has_many :api_clients

  private

  def set_uid
    self.uid = email
  end

  def notify!
    NotificationMode.notify_event! 'UserChanged', user: self.as_json
  end

end
