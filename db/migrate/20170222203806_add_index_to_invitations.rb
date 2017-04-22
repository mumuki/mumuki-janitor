class AddIndexToInvitations < ActiveRecord::Migration[5.0]
  def change
    add_index :invitations, :slug, unique: true
    add_index :invitations, :course_id
  end
end
