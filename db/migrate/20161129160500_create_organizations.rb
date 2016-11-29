class CreateOrganizations < ActiveRecord::Migration[5.0]
  def change
    create_table :organizations do |t|
      t.string :name
      t.text :description
      t.string :book_slug
      t.string :logo_url
      t.string :login_methods
      t.boolean :private
      t.string :contact_email
      t.text :theme_stylesheet

      t.timestamps
    end
  end
end
