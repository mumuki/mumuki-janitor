class ApiClientsController < ApplicationController
  def new
    @api_client = ApiClient.new
  end

  def create
    ApiClient.create! api_client_params
    redirect_to :root
  end

  private

  def api_client_params
    params.require(:api_client).permit(:description, :permissions)
  end
end
