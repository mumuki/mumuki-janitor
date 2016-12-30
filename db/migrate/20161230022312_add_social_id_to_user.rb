class AddSocialIdToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :social_id, :string
  end
end
