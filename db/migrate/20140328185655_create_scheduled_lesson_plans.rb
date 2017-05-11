class CreateScheduledLessonPlans < ActiveRecord::Migration
  def change
    create_table :scheduled_lesson_plans do |t|
      t.date :date
      t.integer :school_year_id
      t.integer :teacher_id
      t.integer :lesson_plan_id

      t.timestamps
    end
    add_index :scheduled_lesson_plans, [ :school_year_id, :teacher_id ]
  end
end
