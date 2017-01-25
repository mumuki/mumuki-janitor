class OrganizationsController < ApplicationController

  include WithOrganization

  before_action :protect_for_owner!, only: :update

  def index
    @organizations = Organization.all
  end

  def new
    @organization = Organization.new
  end

  def create
    with_flash(I18n.t :organization_saved_successfully) do
      @organization = Organization.new organization_params
      @organization.save!
      @organization.notify! 'Created'
    end
  end

  def show
  end

  def update
    with_flash(I18n.t :organization_saved_successfully) do
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

  def with_flash(message, &block)
    block.call
    flash.notice = message
    redirect_to organization_path(@organization)
  rescue => e
    flash.alert = e.message
    render @organization.persisted? ? :show : :new
  end

  def protect_for_owner!
    raise 'Not implemented'
  end

end
