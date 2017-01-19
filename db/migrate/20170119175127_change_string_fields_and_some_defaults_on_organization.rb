class ChangeStringFieldsAndSomeDefaultsOnOrganization < ActiveRecord::Migration[5.0]
  def change
    rename_column :organizations, :private, :public

    change_column :organizations, :login_methods, :text, array: true, default: []
    change_column :organizations, :books, :text, array: true
    change_column :organizations, :terms_of_service, :text
  end
end
