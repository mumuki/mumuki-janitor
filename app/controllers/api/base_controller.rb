module Api
  class BaseController < ApplicationController
    protect_from_forgery with: :null_session

    private

    def params
      ActionController::Parameters.new JSON.parse(request.raw_post)
    end

  end
end