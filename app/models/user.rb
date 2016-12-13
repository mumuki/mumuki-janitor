class User < ApplicationRecord

  include WithPermissions

  validates_presence_of :first_name, :last_name, :email, :uid
  before_validation :set_uid
  after_save :notify!

  private

  def set_uid
    self.uid = email
  end

  def notify!
    Mumukit::Nuntius::EventPublisher.publish 'UserChanged', user: self.as_json
  end

end
