module Api
  class BaseController < ActionController::Base
    protect_from_forgery with: :null_session

    include WithCustomUnhandledErrors
    include WithDynamicErrors
    include WithApiProtection

    def protect_for_janitor!
      protect! :janitor, protection_slug
    end

    def protect_for_owner!
      protect! :janitor, protection_slug
    end

    def protection_slug
      @slug
    end
  end
end