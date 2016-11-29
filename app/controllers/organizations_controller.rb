class OrganizationsController < ApplicationController
  def index
    @organizations = Organization.all
  end

  def show
  end

  def edit
    @organization = Organization.find(params[:id])
  end
end
