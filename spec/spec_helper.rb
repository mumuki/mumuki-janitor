ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

require 'rspec/rails'
require 'mumukit/core/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  config.use_transactional_fixtures = true

  config.infer_base_class_for_anonymous_controllers = false

  config.order = '1'

  config.include FactoryGirl::Syntax::Methods

  config.infer_spec_type_from_file_location!

end

def set_api_client!
  @request.env["HTTP_AUTHORIZATION"] = api_client.token
end

Mumukit::Auth.configure do |c|
  c.clients.default = {id: 'test-client', secret: 'thisIsATestSecret'}
end

Mumukit::Login.configure do |config|
  config.auth0 = struct
  config.saml = struct

  config.mucookie_domain = '.localmumuki.io'
  config.mucookie_secret_key = 'abcde1213456123456'
  config.mucookie_secret_salt = 'mucookie test secret salt'
  config.mucookie_sign_salt = 'mucookie test sign salt'
end

class String
  def parse_json
    JSON.parse(self, symbolize_names: true)
  end
end


RSpec::Matchers.define :json_like do |expected, options={}|
  except = options[:except] || []
  match do |actual|
    actual.as_json.with_indifferent_access.except(*except) == expected.as_json.with_indifferent_access.except(*except)
  end

  failure_message do |actual|
    <<-EOS
    expected: #{expected.as_json.with_indifferent_access.except(*except)} (#{expected.class})
         got: #{actual.as_json.with_indifferent_access.except(*except)} (#{actual.class})
    EOS
  end

  failure_message_when_negated do |actual|
    <<-EOS
    expected: value != #{expected.as_json.with_indifferent_access.except(*except)} (#{expected.class})
         got:          #{actual.as_json.with_indifferent_access.except(*except)} (#{actual.class})
    EOS
  end
end