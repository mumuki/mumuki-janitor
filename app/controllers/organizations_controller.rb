class OrganizationsController < ApplicationController
  include WithOrganization

  def index
    @organizations = Organization.all
  end

  def show
  end

  def update
  end
end
