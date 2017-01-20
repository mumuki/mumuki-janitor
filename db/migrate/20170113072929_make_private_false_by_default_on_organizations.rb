class MakePrivateFalseByDefaultOnOrganizations < ActiveRecord::Migration[5.0]
  def change
    change_column :organizations, :private, :boolean, default: false
    add_index :organizations, :private
  end
end
