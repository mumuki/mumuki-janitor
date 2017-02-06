module WithAuthorization
  extend ActiveSupport::Concern

  private

  def authorize_janitor!
    authorize! :janitor
  end

  def authorize_owner!
    authorize! :owner
  end

  def authorization_slug
    protection_slug || '_/_'
  end

  def protection_slug
    @slug
  end
end
