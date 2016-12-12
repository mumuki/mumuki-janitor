module Api
  class BaseController < ApplicationController
    protect_from_forgery with: :null_session

    private

    def body_params
      ActionController::Parameters.new JSON.parse(request.raw_post)
    end
  end
end