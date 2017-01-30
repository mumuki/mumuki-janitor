module Api
  class UsersController < BaseController
    include UsersControllerTemplate

    def create
      @user.save!
      @user.notify!
      render json: @user
    end

    def update
      @user.update! user_params.except([:email, :permissions, :uid])
      @user.notify!
      render json: @user
    end
  end
end