class ApplicationController < ActionController::Base
  Mumukit::Login.configure_controller! self

  helper_method :login_button

  private

  def login_button(options={})
    login_form.button_html I18n.t(:sign_in), options[:class]
  end

  def login_settings
    Mumukit::Login::Settings.new Mumukit::Login::Settings.login_methods
  end

  def with_flash(model, message, &block)
    block.call
    flash.notice = message
    redirect_to model
  rescue => e
    flash.alert = e.message
    render model.persisted? ? :show : :new
  end

  def protect_for_owner!
    raise 'Not Implemented'
  end

  def protect_for_janitor!
    raise 'Not Implemented'
  end

end
