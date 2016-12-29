class User < ApplicationRecord

  include WithPermissions
  extend WithImport

  has_many :api_clients

  before_validation :set_uid
  after_commit :set_permissions!

  validates_presence_of :first_name, :last_name, :uid

  def notify!
    Mumukit::Nuntius.notify_event!({user: self.as_json}, 'UserChanged')
  end

  private

  def set_uid
    self.uid ||= email
  end
end
