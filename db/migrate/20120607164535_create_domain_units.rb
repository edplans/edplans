class CreateDomainUnits < ActiveRecord::Migration
  def change
    create_table :domain_units do |t|
      t.integer :domain_map_id
      t.integer :teacher_id
      t.string :name

      t.timestamps
    end

    add_index :domain_units, [ :domain_map_id, :teacher_id ]
    add_index :domain_units, :domain_map_id
    add_index :domain_units, :teacher_id
  end
end
