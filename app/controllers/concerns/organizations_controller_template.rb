module OrganizationsControllerTemplate
  extend ActiveSupport::Concern

  included do
    before_action :set_organization!, only: [:show, :update, :edit]
    before_action :set_new_organization!, only: :create
  end

  private

  def set_new_organization!
    @organization = Organization.new organization_params
  end

  def set_organization!
    @organization = Organization.find_by! name: params[:id]
  end

  def protection_slug
    @organization&.slug
  end

  def organization_params
    params.require(:organization).permit(:contact_email, :name, :locale, :description, :logo_url,
                                         :public, :theme_stylesheet, :extension_javascript, :terms_of_service,
                                         :raise_hand_enabled, :community_link,
                                         books: [], login_methods: [])
  end
end
