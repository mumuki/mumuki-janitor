class AddDescriptionToApiClient < ActiveRecord::Migration[5.0]
  def change
    rename_column :api_clients, :name, :description
  end
end
