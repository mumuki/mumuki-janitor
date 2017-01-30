module WithAuthorization
  extend ActiveSupport::Concern

  private

  def authorize!(role, slug)
    current_user.protect! role, slug
  end

  def has_permission?(role, slug)
    current_user.has_permission? role, slug
  end

  def authorize_janitor!
    authorize! :janitor, protection_slug
  end

  def authorize_owner!
    authorize! :janitor, protection_slug
  end

  def protection_slug
    @slug
  end
end
