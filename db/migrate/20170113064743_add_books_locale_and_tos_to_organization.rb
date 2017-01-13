class AddBooksLocaleAndTosToOrganization < ActiveRecord::Migration[5.0]
  def change
    change_table :organizations do |t|
      t.remove :book_slug
      t.string :books, array: true, default: []

      t.string :locale
      t.string :terms_of_service
    end
  end
end
