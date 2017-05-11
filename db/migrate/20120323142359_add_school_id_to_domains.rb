class AddSchoolIdToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :school_id, :integer
    add_index :domains, :school_id
  end
end
