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
end
