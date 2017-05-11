class AddMeasurableObjectivesToLessonPlans < ActiveRecord::Migration
  def change
    add_column :lesson_plans, :measurable_objectives, :text
  end
end
