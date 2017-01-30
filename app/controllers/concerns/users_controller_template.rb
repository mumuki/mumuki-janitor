module UsersControllerTemplate
  extend ActiveSupport::Concern

  included do
    before_action :set_user!, only: [:show, :update]
    before_action :set_new_user!, only: :create

    before_action :protect_for_janitor!
    before_action :protect_delegation!, only: [:create, :update]
  end

  private

  def protection_slug
    '_/_'
  end

  def protect_delegation!
    current_user.protect_delegation! user_params[:permissions]
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :image_url, permissions: Mumukit::Auth::Roles::ROLES)
  end

  def set_user!
    @user = User.find_by uid: params[:id]
  end

  def set_new_user!
    @user = User.new user_params
  end

end
