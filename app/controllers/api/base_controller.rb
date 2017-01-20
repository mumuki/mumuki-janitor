module Api
  class BaseController < ApplicationController
    protect_from_forgery with: :null_session

    include WithCustomUnhandledErrors
    include WithDynamicErrors
    include WithApiProtection

    private

    def verify_authorization_header
      Mumukit::Auth::Token.decode_header(authorization_header).verify_client!
    end

    def authorization_header
      request.env['HTTP_AUTHORIZATION']
    end
  end
end