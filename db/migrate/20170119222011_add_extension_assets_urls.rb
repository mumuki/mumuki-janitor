class AddExtensionAssetsUrls < ActiveRecord::Migration[5.0]
  def change
    change_table :organizations do |t|
      t.string :theme_stylesheet_url

      t.text :extension_javascript
      t.string :extension_javascript_url, default: ''
    end
  end
end
