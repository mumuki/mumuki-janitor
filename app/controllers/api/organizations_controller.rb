module Api

  class OrganizationsController < BaseController
    before_action :set_user
    before_action :protect!

    def create
      organization = Organization.create! organization_params
      organization.notify!
      render json: organization
    end

    private

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