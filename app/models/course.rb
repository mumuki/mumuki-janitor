class Course < ApplicationRecord

  include WithSubscriptionMode

  validates_presence_of :uid, :slug, :shifts, :code, :days, :period, :description, :organization_id

  before_validation :set_uid, :set_organization
  before_create :set_organization
  after_save :notify!

  belongs_to :organization

  private

  def set_uid
    self.uid = slug
  end

  def notify!
    Mumukit::Nuntius::EventPublisher.publish 'CourseChanged', course: self.as_json
  end

  def set_organization
    self.organization = Organization.find_by(name: slug.split('/').first)
  end

end
