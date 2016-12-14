class RemovePermissionsForApiClient < ActiveRecord::Migration[5.0]
  def change
    remove_column :api_clients, :permissions
  end
end
