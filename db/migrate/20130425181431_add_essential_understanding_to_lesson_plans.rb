class AddEssentialUnderstandingToLessonPlans < ActiveRecord::Migration
  def change
    add_column :lesson_plans, :essential_understanding, :text
  end
end
