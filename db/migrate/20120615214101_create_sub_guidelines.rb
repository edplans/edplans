class CreateSubGuidelines < ActiveRecord::Migration
  def change
    create_table :sub_guidelines do |t|
      t.integer :guideline_id
      t.text :name

      t.timestamps
    end

    add_index :sub_guidelines, :guideline_id
  end
end
