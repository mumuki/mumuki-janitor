module Api
  class OrganizationsController < BaseController
    include OrganizationsControllerTemplate

    def index
      render json: Organization.accessible_as(current_user, :janitor).map(&:to_dto!), :except => protected_attributes
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
      render json: obj.to_dto!, :except => protected_attributes
    end

    def protected_attributes
      [:id, :created_at, :updated_at]
    end
  end

end