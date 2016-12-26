module WithDynamicErrors
  extend ActiveSupport::Concern

  included do
    unless Rails.application.config.consider_all_requests_local
      rescue_from ActionController::RoutingError, with: :not_found
    end
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from Mumukit::Auth::UnauthorizedAccessError, with: :forbidden
  end

  def not_found
    render json: {}, status: 404
  end

  private

  def internal_server_error(exception)
    Rails.logger.error "Internal server error: #{exception} \n#{exception.backtrace.join("\n")}"
    render json: {}, status: 500
  end

  def forbidden(exception)
    render  json: {error: exception.message}, status: 403
  end
end
