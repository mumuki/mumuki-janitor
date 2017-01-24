class MakeThemeNotNullable < ActiveRecord::Migration[5.0]
  def change
    change_column :organizations, :theme_stylesheet, :string,  default: ''
  end
end
