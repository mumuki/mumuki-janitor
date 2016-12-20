module Api
  class BaseController < ApplicationController
    protect_from_forgery with: :null_session
    before_filter :verify_authorization_header, :set_api_client
    private

    def verify_authorization_header
      Mumukit::Auth::Token.decode_header(authorization_header).verify_client!
    end

    def set_api_client
      @api_client = ApiClient.find_by!(token: authorization_header.split(' ').last)
    end

    def authorization_header
      request.env['HTTP_AUTHORIZATION']
    end
  end
end