require 'jwt'

module Mumukit::Auth
  class Token
    def self.generate_token
      JWT.encode(
          {aud: Mumukit::Auth.config.client_id},
          decoded_secret)
    end
  end
end
