module WithDynamicErrors
  extend ActiveSupport::Concern

  included do
    unless Rails.application.config.consider_all_requests_local
      rescue_from ActionController::RoutingError, with: :not_found
    end
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from Mumukit::Auth::UnauthorizedAccessError, with: :forbidden
  end

  def not_found(e)
    render_with_status e, 404
  end

  private

  def internal_server_error(e)
    Rails.logger.error "Internal server error: #{e} \n#{e.backtrace.join("\n")}"
    render_with_status e, 500
  end

  def forbidden(e)
    render_with_status e, 403
  end

  private

  def render_with_status(e, status)
    render  json: {error: e.message}, status: status
  end
end
