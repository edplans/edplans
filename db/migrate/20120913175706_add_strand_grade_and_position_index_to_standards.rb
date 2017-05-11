class AddStrandGradeAndPositionIndexToStandards < ActiveRecord::Migration
  def change
    add_index :standards, [ :grade, :strand ]
    add_index :standards, [ :grade, :strand, :position ]
  end
end
