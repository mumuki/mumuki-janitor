class OrganizationsController < ApplicationController

  include WithOrganization
  
  before_action :authenticate!
  before_action :protect_for_owner!, only: [:update, :create]

  def index
    @organizations = Organization.all
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new organization_params
    with_flash @organization, I18n.t(:organization_saved_successfully) do
      @organization.save!
      @organization.notify! 'Created'
    end
  end

  def show
  end

  def update
    with_flash @organization, I18n.t(:organization_saved_successfully) do
      @organization.update_and_notify! organization_params
    end
  end

  helper_method :login_methods

  def login_methods
    ['facebook', 'github', 'google', 'twitter', 'user_pass']
  end

  private

  def organization_params
    params.require(:organization).permit(:contact_email, :name, :locale, :description, :logo_url,
                                         :public, :theme_stylesheet, :extension_javascript, :terms_of_service,
                                         books: [], login_methods: [])
  end
end
