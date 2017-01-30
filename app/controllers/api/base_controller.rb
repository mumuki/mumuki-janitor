module Api
  class BaseController < ActionController::Base
    protect_from_forgery with: :null_session

    include WithCustomUnhandledErrors
    include WithDynamicErrors
    include WithApiProtection

    before_action :verify_token!, :set_api_client!

    private

    def encoded_token
      @encoded_token ||= Mumukit::Auth::Token.extract_from_header(authorization_header)
    end

    def verify_token!
      Mumukit::Auth::Token.decode(encoded_token).verify_client!
    end

    def set_api_client!
      @api_client = ApiClient.find_by! token: encoded_token
    end

    def current_user
      @api_client.user
    end

    def authorization_header
      request.env['HTTP_AUTHORIZATION']
    end
  end
end