class UsersController < ApplicationController
  include UsersControllerTemplate
  before_action :authorize_owner!

  def new
    @user = User.new
  end

  def index
    @users = User.by_full_text(params[:q]).order(:uid).page(params.permit![:page]).per(25)
  end

  def show
  end

  def create
    with_flash @user, I18n.t(:user_saved_successfully) do
      @user.save!
      @user.notify!
    end
  end

  def update
    with_flash @user, I18n.t(:user_saved_successfully) do
      @user.update! user_params
      @user.notify!
    end
  end
end
