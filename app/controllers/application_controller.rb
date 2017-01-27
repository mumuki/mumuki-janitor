class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def with_flash(model, message, &block)
    block.call
    flash.notice = message
    redirect_to model
  rescue => e
    flash.alert = e.message
    render model.persisted? ? :show : :new
  end
  
end
