module Api
  class UsersController < BaseController
    before_action :set_user, only: :update
    def create
      user = User.create! user_params
      user.update_permissions! params[:user][:permissions]
      Mumukit::Nuntius::EventPublisher.publish 'UserChanged', user: user.as_json
      render json: { user: user.as_json }
    end

    def update
      @user.update! user_params.except(:email)
      Mumukit::Nuntius::EventPublisher.publish 'UserChanged', user: @user.as_json
      render json: { user: @user.as_json }
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email)
    end

    def set_user
      @user = User.find_by(email: user_params[:email])
    end
    
  end
end