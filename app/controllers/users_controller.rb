class UsersController < ApplicationController
  def index
    @users = User.order(:uid).page(params.permit![:page]).per(25)
  end

  def show
  end

  def edit
  end


end
