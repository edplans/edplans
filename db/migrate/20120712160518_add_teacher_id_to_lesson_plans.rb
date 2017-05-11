class AddTeacherIdToLessonPlans < ActiveRecord::Migration
  def change
    add_column :lesson_plans, :teacher_id, :integer
    add_index :lesson_plans, :teacher_id
  end
end
