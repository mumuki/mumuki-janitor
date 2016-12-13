class AddUidIndexToUsers < ActiveRecord::Migration[5.0]
  def change
    add_index :users, :uid, unique: true
  end
end
