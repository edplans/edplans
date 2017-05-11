class AddCopiedFromIdToLessonPlans < ActiveRecord::Migration
  def change
    add_column :lesson_plans, :copied_from_id, :integer
    add_index :lesson_plans, :copied_from_id
  end
end
