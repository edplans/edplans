class CreateGuidelines < ActiveRecord::Migration
  def change
    create_table :guidelines do |t|
      t.string :name
      t.text :content
      t.integer :curriculum_node_id
      t.text :notes

      t.timestamps
    end

    add_index :guidelines, :curriculum_node_id
  end
end
