class LoginController < ApplicationController
  Mumukit::Login.configure_login_controller! self

  def failure
  end
end