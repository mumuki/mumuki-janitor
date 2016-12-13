class CreateCourses < ActiveRecord::Migration[5.0]
  def change
    create_table :courses do |t|
      t.string :uid
      t.string :slug
      t.string :days, default: [], null: false, array: true
      t.string :code, null: false
      t.string :shifts, default: [], null: false, array: true
      t.string :period, null: false
      t.string :description, default: '', null: false
      t.integer :subscription_mode, default: 0, null: false
      t.integer :organization_id

      t.timestamps
    end

  end
end
