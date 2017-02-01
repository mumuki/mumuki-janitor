module Api
  class OrganizationsController < BaseController
    include OrganizationsControllerTemplate

    def index
      render json: Organization.accessible_as(current_user, :janitor).map(&:to_dto!)
    end

    def show
      render_dto @organization
    end

    def create
      @organization.save!
      @organization.notify! 'Created'

      render_dto @organization
    end

    def update
      @organization.update_and_notify! organization_params

      render_dto @organization
    end

    private

    def render_dto(obj)
      render json: obj.to_dto!
    end
  end

end