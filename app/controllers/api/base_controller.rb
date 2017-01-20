module Api
  class BaseController < ApplicationController
    protect_from_forgery with: :null_session

    include WithCustomUnhandledErrors
    include WithDynamicErrors
    include WithApiProtection

  end
end