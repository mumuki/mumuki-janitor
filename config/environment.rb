# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

Mumukit::Auth.configure do |c|
  c.client_id = Rails.configuration.auth_client_id
  c.client_secret = Rails.configuration.auth_client_secret
  c.persistence_strategy = Mumukit::Auth::PermissionsPersistence::Daybreak.new 'permissions'
end

Mumukit::Nuntius.configure do |c|
  c.app_name = 'office'
  c.notification_mode = Rails.env.test?? Mumukit::Nuntius::NotificationMode::Deaf.new : Mumukit::Nuntius::NotificationMode.from_env
end
