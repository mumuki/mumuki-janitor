class AddHasMessagesToOrganizations < ActiveRecord::Migration[5.0]
  def change
    add_column :organizations, :raise_hand_enabled, :boolean, default: false
  end
end
