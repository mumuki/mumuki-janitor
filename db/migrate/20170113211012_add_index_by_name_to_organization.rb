class AddIndexByNameToOrganization < ActiveRecord::Migration[5.0]
  def change
    add_index :organizations, :name
  end
end
