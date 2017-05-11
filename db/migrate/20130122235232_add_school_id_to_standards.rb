class AddSchoolIdToStandards < ActiveRecord::Migration
  def change
    add_column :standards, :school_id, :integer
    add_index :standards, :school_id
  end
end
