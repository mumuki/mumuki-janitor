module WithProtection
  extend ActiveSupport::Concern

  included do
    before_action :verify_authorization_header, :set_api_client
  end

  def protect!(role, slug)
    @api_client.protect! role, slug
  end

  private

  def set_api_client
    @api_client = ApiClient.find_by!(token: authorization_header.split(' ').last)
  end
end
