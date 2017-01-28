class UsersController < ApplicationController

  before_action :authenticate!
  before_action :set_user, only: [:show, :update]
  before_action :protect_for_owner!, only: [:update, :create]

  def new
    @user = User.new
  end

  def index
    @users = User.order(:uid).page(params.permit![:page]).per(25)
  end

  def show
  end

  def create
    @user = User.new user_params
    with_flash @user, I18n.t(:user_saved_successfully) do
      @user.save!
      @user.notify!
    end
  end

  def update
    with_flash @user, I18n.t(:organization_saved_successfully) do
      @user.update! user_params
      @user.notify!
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :image_url, permissions: Mumukit::Auth::Roles::ROLES)
  end

  def set_user
    @user = User.find_by uid: params[:id]
  end

  def protect_for_owner!
    raise 'Not Implemented'
  end

end
