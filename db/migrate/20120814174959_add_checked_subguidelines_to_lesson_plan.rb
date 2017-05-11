class AddCheckedSubguidelinesToLessonPlan < ActiveRecord::Migration
  def change
    add_column :lesson_plans, :checked_sub_guidelines, :text
  end
end
