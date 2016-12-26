class User < ApplicationRecord

  include WithPermissions

  has_many :api_clients

  before_validation :set_uid
  after_save :notify!, :set_permissions!

  validates_presence_of :first_name, :last_name, :uid

  def add_student_permission!(grant)
    add_permission! :student, grant
  end

  def update_permissions!(new_permissions)
    self.update! permissions: permissions.merge(Mumukit::Auth::Permissions.parse(new_permissions))
  end

  private

  def add_permission!(role, grant)
    self.permissions.add_permission! role, grant
  end

  def set_uid
    self.uid ||= email
  end

  def notify!
    NotificationMode.notify_event! 'UserChanged', user: self.as_json
  end

  def set_permissions!
    Mumukit::Auth::Store.set! uid, permissions
  end

end
