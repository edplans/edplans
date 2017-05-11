class CreateCurriculumNodes < ActiveRecord::Migration
  def change
    create_table :curriculum_nodes do |t|
      t.string :name
      t.string :ancestry
      t.integer :position
      t.text :notes
      t.text :prior_knowledge
      t.text :resources
      t.text :future_knowledge

      t.timestamps
    end

    add_index :curriculum_nodes, :ancestry
  end
end
