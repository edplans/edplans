class CreateStandardApplications < ActiveRecord::Migration
  def change
    create_table :standard_applications do |t|
      t.integer :standard_id
      t.integer :guideline_id

      t.timestamps
    end

    add_index :standard_applications, :standard_id
    add_index :standard_applications, :guideline_id
  end
end
