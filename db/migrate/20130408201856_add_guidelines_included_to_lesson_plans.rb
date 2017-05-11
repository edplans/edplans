class AddGuidelinesIncludedToLessonPlans < ActiveRecord::Migration
  def change
    add_column :lesson_plans, :guidelines_included, :text
  end
end
