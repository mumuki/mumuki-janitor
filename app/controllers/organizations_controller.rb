class OrganizationsController < ApplicationController

  include WithOrganization

  def index
    @organizations = Organization.all
  end

  def show
    @organization = Organization.find_by!(name: params[:id])
  end

  def update
    organization = Organization.find_by! name: params[:id]
    protect_for_janitor!(organization) if organization.private?
  end

  helper_method :login_methods

  def login_methods
    ['facebook', 'github', 'google', 'twitter', 'user_pass']
  end

end
