class CreateLessonPlanFiles < ActiveRecord::Migration
  def change
    create_table :lesson_plan_files do |t|
      t.integer :lesson_plan_id
      t.string :attachment_file_name
      t.string :attachment_content_type
      t.integer :attachment_file_size
      t.datetime :attachment_updated_at

      t.timestamps
    end
    add_index :lesson_plan_files, :lesson_plan_id
  end
end
