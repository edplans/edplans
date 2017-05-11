class CreateDomainMaps < ActiveRecord::Migration
  def change
    create_table :domain_maps do |t|
      t.integer :school_id
      t.integer :domain_id
      t.text :guideline_ids

      t.timestamps
    end

    add_index :domain_maps, [ :school_id, :domain_id ]
  end
end
