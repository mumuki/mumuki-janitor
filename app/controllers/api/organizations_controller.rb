module Api

  class OrganizationsController < BaseController
    before_action :set_user
    before_action :protect!, except: :all

    def index
      organizations = Organization.where private: false
      render json: organizations
    end

    def show
      organization = Organization.find id_param
      render json: organization
    end

    def create
      organization = Organization.create! organization_params
      organization.notify!
      render json: organization
    end

    def update
      organization = Organization.find id_param
      organization.update_attributes organization_params
      organization.validate
      render json: organization
    end

    private

    def id_param
      params[:id]
    end

    def organization_params
      params.permit(:contact_email, :name, :locale, :description, :logo_url,
                    :login_methods, :private, :theme_stylesheet, :terms_of_service,
                    books: [])
    end

    def set_user
      @user = User.find_by(id: @api_client.user_id)
    end

    def protect!
      @api_client.protect! :owner, '*'
    end
  end

end