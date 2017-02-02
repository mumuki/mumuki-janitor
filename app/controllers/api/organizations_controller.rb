module Api
  class OrganizationsController < BaseController
    include OrganizationsControllerTemplate

    def index
      render json: { organizations: Organization.accessible_as(current_user, :janitor).map(&:as_dto) }
    end

    def show
      render_dto @organization
    end

    def create
      @organization.save!
      @organization.notify_created!

      render_dto @organization
    end

    def update
      @organization.update_and_notify! organization_params

      render_dto @organization
    end

    private

    def render_dto(obj)
      render json: obj.as_dto
    end
  end

end