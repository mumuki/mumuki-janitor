class AddIndexToInvitationsBySlug < ActiveRecord::Migration[5.0]
  def change
    add_index :invitations, :slug, unique: true
  end
end
