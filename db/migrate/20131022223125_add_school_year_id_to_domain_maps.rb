class AddSchoolYearIdToDomainMaps < ActiveRecord::Migration
  def change
    add_column :domain_maps, :school_year_id, :integer
    add_index :domain_maps, [ :domain_id, :school_year_id ]
  end
end
