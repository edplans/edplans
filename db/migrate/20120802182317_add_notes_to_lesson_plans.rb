class AddNotesToLessonPlans < ActiveRecord::Migration
  def change
    add_column :lesson_plans, :team_notes, :text
    add_column :lesson_plans, :personal_notes, :text
  end
end
