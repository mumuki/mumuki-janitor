module WithCustomUnhandledErrors
  extend ActiveSupport::Concern

  included do
    rescue_from Exception do |e| unhandled_error!(e) end
  end

  private

  def unhandled_error!(e)
    summary = {
        errors: {
            :exception => "#{e.class.name} : #{e.message}"
        }
    }
    summary[:trace] = e.backtrace[0, 10] if Rails.env.development?

    render json: summary, status: :internal_server_error
  end
end
