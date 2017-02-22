class Invitation < ApplicationRecord

  validates_presence_of :course, :expiration_date
  before_save :set_slug!

  belongs_to :course

  def self.all_of(course)
    Invitation
        .where(course: course)
        .where Invitation.arel_table[:expiration_date].gt(Date.today)
  end

  def notify!
    Mumukit::Nuntius.notify_event! 'InvitationCreated', invitation: as_json
  end

  def as_json(options = nil)
    super.except('id', 'course_id').merge({
        course: course.slug,
        url: url
    })
  end

  private

  def url
    "http://mumuki.io/join/#{slug}" # // TODO: Deshardcodear ruta a labo
  end

  def set_slug!
    self.slug = "#{SecureRandom.hex.slice(0, 4)}-#{course.name}"
  end

end
