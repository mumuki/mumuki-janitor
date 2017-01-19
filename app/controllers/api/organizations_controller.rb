module Api

  class OrganizationsController < BaseController
    before_action :set_user!

    include WithOrganization

    def index
      render json: Organization.accessible_as(@api_client, :janitor)
    end

    def show
      protect_for_janitor!(@organization) if (@organization.is_private?)
      render json: @organization
    end

    def create
      protect_for_owner! Organization.new organization_params
      organization = Organization.create! organization_params
      organization.notify! 'Created'
      render json: organization
    end

    def update
      protect_for_owner! @organization

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

    def set_user!
      @user = User.find_by(id: @api_client.user_id)
    end

    def protect_for_janitor!(organization)
      protect! :janitor, organization.slug
    end

    def protect_for_owner!(organization)
      protect! :owner, organization.slug
    end
  end

end