module WithApiProtection
  extend ActiveSupport::Concern

  included do
    before_action :verify_token!, :set_api_client!
  end

  def protect!(role, slug)
    @api_client.user.protect! role, slug
  end

  def has_permission?(role, slug)
    @api_client.user.has_permission? role, slug
  end

  private

  def set_api_client!
    @api_client = ApiClient.find_by! token: encoded_token
  end

  def verify_token!
    Mumukit::Auth::Token.decode(encoded_token).verify_client!
  end

  def encoded_token
    @encoded_token ||= Mumukit::Auth::Token.extract_from_header(authorization_header)
  end

  def authorization_header
    request.env['HTTP_AUTHORIZATION']
  end
end
