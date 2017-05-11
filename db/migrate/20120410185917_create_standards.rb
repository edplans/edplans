class CreateStandards < ActiveRecord::Migration
  def change
    create_table :standards do |t|
      t.string :subject
      t.integer :position
      t.string :ck_code
      t.string :ck_align
      t.string :strand_code
      t.string :strand
      t.string :category
      t.text :text
      t.string :origin

      t.timestamps
    end

    add_index :standards, :subject
    add_index :standards, :ck_code
    add_index :standards, :strand
    add_index :standards, :category
  end
end
