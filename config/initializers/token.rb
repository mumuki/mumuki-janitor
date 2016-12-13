require 'jwt'

module Mumukit::Auth
  class Token
    def self.encode(permissions)
      JWT.encode(
          {aud: Mumukit::Auth.config.client_id,
           permissions: permissions},
          decoded_secret)
    end
  end
end
