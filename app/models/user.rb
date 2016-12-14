class User < ApplicationRecord

  include WithPermissions

  validates_presence_of :first_name, :last_name, :email, :uid
  before_validation :set_uid
  after_save :notify!
  has_many :api_clients

  def add_student_permission!(permission)
    add_permission! :student, permission
  end

  private

  def add_permission!(type, permission)
    self.permissions[type] ||= ''
    permissions = self.permissions[type].split(':')
    permissions << permission
    self.permissions[type] = permissions.join(':')
  end

  def set_uid
    self.uid = email
  end

  def notify!
    NotificationMode.notify_event! 'UserChanged', user: self.as_json
  end

end
