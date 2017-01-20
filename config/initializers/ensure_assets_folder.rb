def ensure_dir!(dir)
    FileUtils.mkdir_p "#{Rails.public_path.to_s}/#{dir}"
end

ensure_dir! "stylesheets"
ensure_dir! "javascripts"
