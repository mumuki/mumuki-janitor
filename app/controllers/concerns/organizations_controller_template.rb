module OrganizationsControllerTemplate
  extend ActiveSupport::Concern

  included do
    before_action :set_organization!, only: [:show, :update, :edit]

    before_action :protect_for_janitor!, only: :show
    before_action :protect_for_owner!, only: :update
  end

  private

  def set_organization!
    @organization = Organization.find_by! name: params[:id]
  end

  def protection_slug
    @organization.slug
  end

  def organization_params
    params.require(:organization).permit(:contact_email, :name, :locale, :description, :logo_url,
                                         :public, :theme_stylesheet, :extension_javascript, :terms_of_service,
                                         books: [], login_methods: [])
  end
end
