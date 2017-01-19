module Api

  class OrganizationsController < BaseController
    before_action :set_user

    def index
      organizations = Organization.all.select do |it|
        it.public || has_permission?(:janitor, it.slug)
      end
      render json: organizations
    end

    def show
      organization = Organization.find_by_name id_param
      protect_for_janitor!(organization) if (organization.is_private?)
      render json: organization
    end

    def create
      protect_for_owner! Organization.new organization_params
      organization = Organization.create! organization_params
      organization.notify!
      render json: organization
    end

    def update
      organization = Organization.find_by_name id_param
      protect_for_owner! organization

      organization.update_attributes organization_params
      organization.save!
      render json: organization
    end

    private

    def id_param
      params[:id]
    end

    def organization_params
      params.permit(:contact_email, :name, :locale, :description, :logo_url,
                    :public, :theme_stylesheet, :terms_of_service,
                    books: [], login_methods: [])
    end

    def set_user
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