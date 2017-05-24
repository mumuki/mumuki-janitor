class HomeController < ApplicationController
  before_action :authorize_owner!
 
  def index
  end
end
