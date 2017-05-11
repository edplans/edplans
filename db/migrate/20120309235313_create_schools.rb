class CreateSchools < ActiveRecord::Migration
  def change
    create_table :schools do |t|
      t.integer :planner_id
      t.string :name
      t.date :year_start
      t.date :year_end
      t.text :holidays
      t.string :grades

      t.timestamps
    end

    add_index :schools, :planner_id
  end
end
