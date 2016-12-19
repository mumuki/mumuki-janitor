class User < ApplicationRecord

  include WithPermissions

  has_many :api_clients

  before_validation :set_uid
  after_save :notify!, :set_permissions!

  validates_presence_of :first_name, :last_name, :email, :uid

  def add_student_permission!(grant)
    add_permission! :student, grant
  end

  private

  def add_permission!(role, grant)
    self.permissions.add_permission! role, grant
  end

  def set_uid
    self.uid = email
  end

  def notify!
    NotificationMode.notify_event! 'UserChanged', user: self.as_json
  end

  def set_permissions!
    Mumukit::Auth::Store.new(:permissions).set! uid, permissions
  end

end
