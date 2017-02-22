class Course < ApplicationRecord

  extend WithImport

  validates_presence_of :uid, :slug, :shifts, :code, :days, :period, :description, :organization_id

  before_validation :set_uid, :set_organization
  before_create :set_organization

  belongs_to :organization
  has_many :invitations

  def notify!
    Mumukit::Nuntius.notify_event! 'CourseChanged', course: event_json
  end

  def event_json
    as_json except: :id
  end

  def name
    Mumukit::Auth::Slug.parse(slug).course
  end

  private

  def set_uid
    self.uid = slug
  end

  def set_organization
    self.organization = Organization.find_by(name: Mumukit::Auth::Slug.parse(slug).organization)
  end

end
