module Api
  class UsersController < BaseController
    before_action :set_user, only: :update
    def create
      user = User.create! user_params
      render json: { user: user }
    end

    def update
      @user.update! user_params.except([:email, :permissions, :uid])
      render json: { user: @user }
    end

    private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, permissions: Mumukit::Auth::Permissions.keys)
    end

    def set_user
      @user = User.find_by(uid: params[:id])
    end
  end
end