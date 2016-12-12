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

    def user_params
      body_params.require(:user).permit(:first_name, :last_name, :email, permissions: Mumukit::Auth::Permissions.keys)
    end

    def set_user
      @user = User.find_by(uid: params[:uid])
    end
    
  end
end