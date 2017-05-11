class ChangeLessonPlansParentToDomainUnit < ActiveRecord::Migration
  def up
    LessonPlan.delete_all
    remove_column :lesson_plans, :domain_map_id
    remove_column :lesson_plans, :teacher_id
    add_column :lesson_plans, :domain_unit_id, :integer
    add_index :lesson_plans, :domain_unit_id
  end

  def down
    remove_column :lesson_plans, :domain_unit_id
    add_column :lesson_plans, :domain_map_id, :integer
    add_column :lesson_plans, :teacher_id, :integer
    add_index :lesson_plans, :domain_map_id
    add_index :lesson_plans, :teacher_id
  end
end
