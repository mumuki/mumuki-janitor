class ThemesController < ApplicationController
  include WithRequestedOrganization

  def show
    organization = requested_organization
    render inline: organization.theme_stylesheet, content_type: 'text/css'
  end
end
