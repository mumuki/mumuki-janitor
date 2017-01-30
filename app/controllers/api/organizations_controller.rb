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
      @organization.update_attributes organization_params
      @organization.save!
      @organization.notify! 'Updated'
      render json: @organization
    end

    private

    def organization_params
      params.permit(:contact_email, :name, :locale, :description, :logo_url,
                    :public, :theme_stylesheet, :extension_javascript, :terms_of_service,
                    books: [], login_methods: [])
    end

    def protection_slug
      @organization.slug
    end
  end

end