class UpdatePermissionsToApiclient < ActiveRecord::Migration[5.0]
  def change
    change_column :api_clients, :permissions, :text, default: '{}', null: false
  end
end
