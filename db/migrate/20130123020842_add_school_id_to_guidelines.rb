class AddSchoolIdToGuidelines < ActiveRecord::Migration
  def change
    add_column :guidelines, :school_id, :integer
    add_index :guidelines, :school_id
  end
end
