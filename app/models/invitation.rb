class Invitation < ApplicationRecord

  before_validation :set_slug
  validates_presence_of :slug, :course, :expiration_date

  belongs_to :course

  def self.all_of(course)
    Invitation.where course: course
  end

  def notify! # // TODO: Llamar
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
    "http://mumuki.io/join/#{slug}" # // TODO: Cambiar
  end

  def set_slug
    self.slug = "prueba" # // TODO: Cambiar
  end

end
