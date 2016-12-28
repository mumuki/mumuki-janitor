class User < ApplicationRecord

  include WithPermissions

  has_many :api_clients

  before_validation :set_uid
  after_commit :set_permissions!

  validates_presence_of :first_name, :last_name, :uid

  def self.import_from_json!(user_data)
    User.where(uid: user_data[:uid]).assign_first(user_data).save!
  end

  def notify!
    Mumukit::Nuntius.notify_event!({user: self.as_json}, 'UserChanged')
  end

  private

  def set_uid
    self.uid ||= email
  end
end
