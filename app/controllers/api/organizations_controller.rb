module Api

  class OrganizationsController < BaseController
    before_action :set_user, except: [:index]
    before_action :protect_for_god!, only: [:create]
    skip_before_action :verify_authorization_header, only: [:index]
    skip_before_action :set_api_client, only: [:index]

    def index
      organizations = Organization.where private: false
      render json: organizations
    end

    def show
      organization = Organization.find_by_name id_param
      protect_for_janitor!(organization) if (organization.private)
      render json: organization
    end

    def create
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
                    :private, :theme_stylesheet, :terms_of_service,
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

    def protect_for_god!
      protect! :owner, 'academy/*'
    end

    def protect!(role, slug)
      @api_client.protect! role, slug
    end
  end

end