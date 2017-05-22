## Development defaults
if ENV['RAILS_ENV'] == 'development' || ENV['RACK_ENV'] == 'development'
  ENV['MUMUKI_ORGANIZATION_MAPPING'] ||= 'path'
  ENV['SECRET_KEY_BASE'] ||= 'aReallyStrongKeyForDevelopment'
end

## Require code
require_relative 'config/environment'

## Essential parameters validation
raise 'Missing secret key' unless Mumukit::Login.config.mucookie_secret_key

## Start server
run Rails.application