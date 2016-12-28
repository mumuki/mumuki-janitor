class Course < ApplicationRecord

  include WithSubscriptionMode

  validates_presence_of :uid, :slug, :shifts, :code, :days, :period, :description, :organization_id

  before_validation :set_uid, :set_organization
  before_create :set_organization

  belongs_to :organization

  def add_student!(user)
    User.where(uid: user[:uid]).first_or_create(user).tap do |s|
      s.add_student_permission! slug
      s.save!
      s.notify!
    end
  end

  def notify!
    Mumukit::Nuntius.notify_event! 'CourseChanged', course: self.as_json
  end

  private

  def set_uid
    self.uid = slug
  end

  def set_organization
    self.organization = Organization.find_by(name: Mumukit::Auth::Slug.parse(slug).organization)
  end

end
