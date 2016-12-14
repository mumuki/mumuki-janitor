class AddUserToApiClient < ActiveRecord::Migration[5.0]
  def change
    add_column :api_clients, :user_id, :integer
  end
end
