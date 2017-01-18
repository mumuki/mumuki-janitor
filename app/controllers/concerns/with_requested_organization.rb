module WithRequestedOrganization
  extend ActiveSupport::Concern

  included do
    unless Rails.application.config.consider_all_requests_local
      rescue_from ActionController::RoutingError, with: :not_found
    end
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from Mumukit::Auth::UnauthorizedAccessError, with: :forbidden
  end

  def requested_organization
    Organization.find_by_name(id_param) || raise(ActiveRecord::RecordNotFound)
  end

  private

  def id_param
    params[:id]
  end
end
