module WithApiProtection
  extend ActiveSupport::Concern

  private

  def protect!(role, slug)
    current_user.protect! role, slug
  end

  def has_permission?(role, slug)
    current_user.has_permission? role, slug
  end

  def protect_for_janitor!
    protect! :janitor, protection_slug
  end

  def protect_for_owner!
    protect! :janitor, protection_slug
  end

  def protection_slug
    @slug
  end
end
