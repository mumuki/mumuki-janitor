module WithOrganization
  extend ActiveSupport::Concern

  included do
    before_action :set_organization!, only: [:show, :update, :edit]
  end

  private

  def set_organization!
    @organization = Organization.find_by! name: id_param
  end

  def id_param
    params[:id]
  end

end
