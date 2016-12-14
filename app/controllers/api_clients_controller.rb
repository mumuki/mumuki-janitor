class ApiClientsController < ApplicationController
  before_action :parse_permissions, only: :create
  def new
    @api_client = ApiClient.new
    @user = @api_client.build_user
  end

  def create
    ApiClient.create! api_client_params
    redirect_to :root
  end

  private

  def api_client_params
    params.require(:api_client).permit(:description, user_attributes: [:first_name, :last_name, :email, permissions: Mumukit::Auth::Permissions.keys])
  end

  def parse_permissions
    ApiClient.parse! params[:api_client][:user_attributes]
  end
end
