class AddSchoolIdToDomainUnits < ActiveRecord::Migration
  def change
    add_column :domain_units, :school_id, :integer
    add_index :domain_units, :school_id
  end
end
