module WithSass
  extend ActiveSupport::Concern

  included do
    before_save :compile_sass!
  end

  def compile_sass!
    file = Tempfile.write!(self.theme_stylesheet)
    self.theme_stylesheet = Sass::Engine.for_file(file.path, syntax: :scss).render
  end

end

