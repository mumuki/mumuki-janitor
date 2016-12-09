module Api
  class UsersController < BaseController
    def create
      user = User.create! user_params
      user.update_permissions! params[:user][:permissions]
      render json: { user: user.as_json }
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email)
    end
    
  end
end