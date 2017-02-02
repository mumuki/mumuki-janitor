module Api
  class OrganizationsController < BaseController
    include OrganizationsControllerTemplate

    def index
      render json: { organizations: Organization.accessible_as(current_user, :janitor) }
    end

    def show
      render json: @organization
    end

    def create
      @organization.save!
      @organization.notify_created!

      render json: @organization
    end

    def update
      @organization.update_and_notify! organization_params

      render json: @organization
    end
  end

end