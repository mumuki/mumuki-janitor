class RemoveSubscriptionModeFromCourse < ActiveRecord::Migration[5.0]
  def change
    remove_column :courses, :subscription_mode
  end
end
