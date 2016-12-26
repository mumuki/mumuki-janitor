class Course < ApplicationRecord

  include WithSubscriptionMode

  validates_presence_of :uid, :slug, :shifts, :code, :days, :period, :description, :organization_id

  before_validation :set_uid, :set_organization
  before_create :set_organization
  after_save :notify!

  belongs_to :organization

  def add_student!(user)
    student = User.where(uid: user[:uid]).first_or_create(user)
    student.add_student_permission! slug
    student.save!
  end

  private

  def set_uid
    self.uid = slug
  end

  def notify!
    NotificationMode.notify_event! 'CourseChanged', course: self.as_json
  end

  def set_organization
    self.organization = Organization.find_by(name: Mumukit::Auth::Slug.parse(slug).organization)
  end

end
