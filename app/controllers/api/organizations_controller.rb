module Api

  class OrganizationsController < BaseController
    before_action :set_user
    before_action :protect!

    def create
      render json: { test: @user }
    end

    private

    def set_user
      @user = User.find_by(id: @api_client.user_id)
    end

    def protect!
      @api_client.protect! :owner, '*'
    end
  end

end