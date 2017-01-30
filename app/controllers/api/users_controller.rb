module Api
  class UsersController < BaseController
    before_action :set_user, only: :update
    before_action :protect_delegation!, only: [:create, :update]
    def create
      user = User.create! user_params
      user.notify!
      render json: { user: user }
    end

    def update
      @user.update! user_params.except([:email, :permissions, :uid])
      @user.notify!
      render json: { user: @user }
    end

    private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :image_url, permissions: Mumukit::Auth::Roles::ROLES)
    end

    def set_user
      @user = User.find_by(uid: params[:id])
    end

    def protect_delegation!
      current_user.protect_delegation! user_params[:permissions]
    end
  end
end