def ensure_dir!(dir)
    FileUtils.mkdir_p File.join(Rails.public_path, dir)
end

ensure_dir! "stylesheets"
ensure_dir! "javascripts"
