class ThemesController < ApplicationController
  include WithOrganization

  def show
    render inline: @organization.theme_stylesheet, content_type: 'text/css'
  end
end
