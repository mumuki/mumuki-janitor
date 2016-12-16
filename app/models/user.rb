class User < ApplicationRecord

  include WithPermissions

  has_many :api_clients

  after_initialize :init
  before_validation :set_uid
  after_save :notify!

  validates_presence_of :first_name, :last_name, :email, :uid

  def add_student_permission!(permission)
    add_permission! 'student', permission
  end

  private

  def add_permission!(type, permission)
    self.permissions.add_permission! type, permission
  end

  def set_uid
    self.uid = email
  end

  def notify!
    NotificationMode.notify_event! 'UserChanged', user: self.as_json
  end

  private

  def init
    self.permissions ||= Mumukit::Auth::Permissions.parse({})
  end

end
