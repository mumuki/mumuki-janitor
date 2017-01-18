class OrganizationsController < ApplicationController
  include WithRequestedOrganization

  def index
    @organizations = Organization.all
  end

  def show
  end

  def edit
    @organization = requested_organization
  end
end
