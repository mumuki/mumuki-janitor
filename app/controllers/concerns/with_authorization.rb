module WithAuthorization
  extend ActiveSupport::Concern

  private

  def authorize!(role)
    current_user.protect! role, (protection_slug || '_/_')
  end

  def has_permission?(role, slug)
    current_user.has_permission? role, slug
  end

  def authorize_janitor!
    authorize! :janitor
  end

  def authorize_owner!
    authorize! :owner
  end

  def protection_slug
    @slug
  end
end
