module WithStaticAssets
  extend ActiveSupport::Concern

  included do
    before_save :generate_stylesheet!
    before_save :generate_javascript!
  end

  private

  def generate_stylesheet!
    generate_asset! 'stylesheets', :theme_stylesheet_css, :theme_stylesheet_url, 'css'
  end

  def generate_javascript!
    generate_asset! 'javascripts', :extension_javascript, :extension_javascript_url, 'js'
  end

  def generate_asset!(directory, property, url_property, extension)
    content = send property
    return send "#{url_property}=", nil if !base? and content.nil?

    path = File.join(directory, "#{name}-#{Digest::SHA1.hexdigest content}.#{extension}")

    delete_previous_asset! url_property
    File.open(full_path_for(path), 'w') { |f| f << content }
    send "#{url_property}=", path
  end

  def delete_previous_asset!(url_property)
    relative_path = send url_property
    return if relative_path.nil?
    FileUtils.rm_f full_path_for(relative_path)
  end

  def full_path_for(path)
    "#{Rails.public_path.to_s}/#{path}"
  end
end
