# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

Mumukit::Auth.configure do |c|

end

Mumukit::Nuntius.configure do |c|
  c.app_name = 'office'
  c.notification_mode = Mumukit::Nuntius::NotificationMode.from_env
end
