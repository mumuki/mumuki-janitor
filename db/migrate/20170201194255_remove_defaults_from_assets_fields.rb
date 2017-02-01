class RemoveDefaultsFromAssetsFields < ActiveRecord::Migration[5.0]
  def change
    change_column :organizations, :extension_javascript_url, :string

    change_column :organizations, :theme_stylesheet, :text, default: nil
    change_column :organizations, :extension_javascript, :text, default: nil
  end
end
