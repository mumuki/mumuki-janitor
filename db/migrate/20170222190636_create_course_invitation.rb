class CreateCourseInvitation < ActiveRecord::Migration[5.0]
  def change
    create_table :invitations do |t|
      t.integer :course_id
      t.string :slug
      t.date :expiration_date
    end
  end
end
