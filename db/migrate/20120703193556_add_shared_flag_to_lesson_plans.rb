class AddSharedFlagToLessonPlans < ActiveRecord::Migration
  def change
    add_column :lesson_plans, :shared, :boolean, :default => true
    add_index :lesson_plans, [ :school_id, :shared ]
  end
end
