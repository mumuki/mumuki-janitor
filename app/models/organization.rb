class Organization < ApplicationRecord
  validates_presence_of :contact_email, :name, :locale
  validates :books, :length => { minimum: 1 }
  validates :locale, :inclusion => { :in => %w(es-AR en-US) }

  def notify!
    Mumukit::Nuntius.notify_event!({organization: as_json}, 'OrganizationCreated')
  end
end
