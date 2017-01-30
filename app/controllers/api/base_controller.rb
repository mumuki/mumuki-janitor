module Api
  class BaseController < ActionController::Base
    protect_from_forgery with: :null_session

    include WithCustomUnhandledErrors
    include WithDynamicErrors
    include WithApiProtection

    before_action :verify_token!, :set_api_client!

    private

    def protect_for_janitor!
      protect! :janitor, protection_slug
    end

    def protect_for_owner!
      protect! :janitor, protection_slug
    end

    def protection_slug
      @slug
    end

    def current_user
      @api_client.user
    end
  end
end