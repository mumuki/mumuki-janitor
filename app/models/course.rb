class Course < ApplicationRecord

  validates_presence_of :uid, :slug, :shifts, :code, :days, :period,
                        :description, :subscription_mode, :organization_id
  before_validation :set_uid, :set_submission_mode
  after_validation :notify!

  private

  def set_uid
    self.uid = slug
  end

  def notify!
    Mumukit::Nuntius::EventPublisher.publish 'CourseChanged', course: self.as_json
  end

  def set_submission_mode
    self.subscription_mode = [:open, :closed].find_index(subscription_mode)
  end

end
