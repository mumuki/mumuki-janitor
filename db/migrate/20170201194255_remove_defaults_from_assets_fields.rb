class RemoveDefaultsFromAssetsFields < ActiveRecord::Migration[5.0]
  def change
    change_column :organizations, :theme_stylesheet, :text
    change_column :organizations, :extension_javascript, :text
    change_column :organizations, :extension_javascript_url, :string
  end
end
