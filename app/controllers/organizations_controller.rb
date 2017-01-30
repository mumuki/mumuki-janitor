class OrganizationsController < ApplicationController
  helper_method :login_methods

  include OrganizationsControllerTemplate

  def index
    @organizations = Organization.accessible_as(current_user, :janitor)
  end

  def show
  end

  def new
    @organization = Organization.new
  end

  def create
    with_flash @organization, I18n.t(:organization_saved_successfully) do
      @organization.save!
      @organization.notify! 'Created'
    end
  end

  def update
    with_flash @organization, I18n.t(:organization_saved_successfully) do
      @organization.update_and_notify! organization_params
    end
  end

  private

  def login_methods
    Mumukit::Login::Setting.login_settings
  end
end
