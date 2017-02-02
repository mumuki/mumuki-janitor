require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Janitor
  class Application < Rails::Application
    config.generators.stylesheets = false
    config.generators.javascripts = false

    config.generators.test_framework = :rspec

    config.base_organization_name = ENV['MUMUKI_BASE_ORGANIZATION_NAME'] || 'base'
  end
end
