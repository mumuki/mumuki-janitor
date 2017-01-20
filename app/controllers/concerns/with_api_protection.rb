module WithApiProtection
  extend ActiveSupport::Concern

  included do
    before_action :verify_authorization_header, :set_api_client
  end

  def protect!(role, slug)
    @api_client.protect! role, slug
  end

  def has_permission?(role, slug)
    @api_client.has_permission? role, slug
  end

  private

  def set_api_client
    @api_client = ApiClient.find_by! token: Mumukit::Auth::Token.extract_from_header(authorization_header)
  end

  def verify_authorization_header
    Mumukit::Auth::Token.decode_header(authorization_header).verify_client!
  end

  def authorization_header
    request.env['HTTP_AUTHORIZATION']
  end
end
