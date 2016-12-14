class CreateCourses < ActiveRecord::Migration[5.0]
  def change
    create_table :courses do |t|
      t.string :uid
      t.string :slug
      t.string :days
      t.string :code
      t.string :shifts
      t.string :period
      t.string :description
      t.integer :subscription_mode, default: 0
      t.integer :organization_id

      t.timestamps
    end

  end
end
