module WithOrganization
  extend ActiveSupport::Concern

  def requested_organization
    Organization.find_by_name(id_param) || raise(ActiveRecord::RecordNotFound)
  end

  private

  def id_param
    params[:id]
  end
end
