module WithStaticAssets
  extend ActiveSupport::Concern

  included do
    before_save :generate_stylesheet!
    before_save :generate_javascript!
  end

  private

  def generate_stylesheet!
    generate_assets!'stylesheets', 'theme_stylesheet'
  end

  def generate_javascript!
    generate_assets! 'javascripts', 'extension_javascript'
  end

  def generate_assets!(directory, property)
    content = send property
    path = "#{directory}/#{name}-#{SecureRandom.hex}"

    File.open("#{Rails.public_path.to_s}/#{path}", 'w') { |f| f << content }
    send "#{property}_url=", path
  end
end
