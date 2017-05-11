class CreateLessonPlans < ActiveRecord::Migration
  def change
    create_table :lesson_plans do |t|
      t.string :name
      t.integer :teacher_id
      t.integer :school_id
      t.integer :domain_map_id
      t.text :prerequisite_skills
      t.text :read_aloud_resources
      t.text :materials
      t.text :procedure
      t.text :comprehension_questions
      t.text :extension_activity
      t.text :scaffolding_and_support
      t.text :assessment_methods

      t.timestamps
    end

    add_index :lesson_plans, :teacher_id
    add_index :lesson_plans, :school_id
    add_index :lesson_plans, :domain_map_id
    add_index :lesson_plans, [ :teacher_id, :domain_map_id ]
    add_index :lesson_plans, [ :school_id, :domain_map_id ]
  end
end
