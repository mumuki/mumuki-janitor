class AddCommunityLinkToOrganizations < ActiveRecord::Migration[5.0]
  def change
    add_column :organizations, :community_link, :string
  end
end
