class AddPublicNotesToLessonPlans < ActiveRecord::Migration
  def change
    add_column :lesson_plans, :public_notes, :text
  end
end
