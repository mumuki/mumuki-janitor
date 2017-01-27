class UsersController < ApplicationController

  before_action :set_user, only: :show

  def new
    @user = User.new
  end

  def index
    @users = User.order(:uid).page(params.permit![:page]).per(25)
  end

  def show
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :image_url, permissions: Mumukit::Auth::Roles::ROLES)
  end

  def set_user
    @user = User.find_by uid: params[:id]
  end

end
