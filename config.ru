# This file is used by Rack-based servers to start the application.

if ENV['RAILS_ENV'] == 'development' || ENV['RACK_ENV'] == 'development'
  ENV['MUMUKI_ORGANIZATION_MAPPING'] ||= 'path'
  ENV['SECRET_KEY_BASE'] ||= 'aReallyStrongKeyForDevelopment'
end

require_relative 'config/environment'

run Rails.application
