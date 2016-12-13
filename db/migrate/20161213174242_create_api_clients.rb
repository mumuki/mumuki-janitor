class CreateApiClients < ActiveRecord::Migration[5.0]
  def change
    create_table :api_clients do |t|
      t.string :permissions
      t.string :name
      t.string :token

      t.timestamps
    end
  end
end
