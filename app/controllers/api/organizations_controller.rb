module Api
  class OrganizationsController < BaseController
    include OrganizationsControllerTemplate

    def index
      render json: Organization.accessible_as(current_user, :janitor)
    end

    def show
      render json: @organization
    end

    def create
      @organization = Organization.new organization_params
      protect_for_owner!

      @organization.save!
      @organization.notify! 'Created'

      render json: @organization
    end

    def update
      @organization.update! organization_params
      @organization.notify! 'Updated'
      render json: @organization
    end
  end

end