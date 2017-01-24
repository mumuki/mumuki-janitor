module WithSass
  extend ActiveSupport::Concern

  included do
    before_save :compile_sass!
    attr_accessor :theme_stylesheet_css
  end

  private

  def compile_sass!
    file = Tempfile.write!(self.theme_stylesheet)
    @theme_stylesheet_css = Sass::Engine.for_file(file.path, syntax: :scss).render
  end
end

