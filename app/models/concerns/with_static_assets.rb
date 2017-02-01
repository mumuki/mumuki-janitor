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
    return inherit_url_from_base! url_property if !base? and content.nil?

    path = File.join(directory, "#{name}-#{Digest::SHA1.hexdigest content}.#{extension}")

    delete_previous_asset! url_property
    File.open(full_path_for(path), 'w') { |f| f << content }
    send "#{url_property}=", path

    update_inheritors_urls! url_property, path if base?
  end

  def delete_previous_asset!(url_property)
    relative_path = send url_property
    return if relative_path.nil?
    FileUtils.rm_f full_path_for(relative_path)
  end

  def inherit_url_from_base!(url_property)
    delete_previous_asset! url_property
    send "#{url_property}=", self.class.base.send(url_property)
  end

  def update_inheritors_urls!(url_property, path)
    self.class.where({ url_property => nil })
              .update_all({ url_property => path })
  end

  def full_path_for(path)
    "#{Rails.public_path.to_s}/#{path}"
  end
end
