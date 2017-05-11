class CreateScheduledDomains < ActiveRecord::Migration
  def change
    create_table :scheduled_domains do |t|
      t.integer :school_id
      t.integer :domain_id
      t.integer :start_week
      t.string :grade
      t.integer :weeks

      t.timestamps
    end

    add_index :scheduled_domains, :school_id
    add_index :scheduled_domains, [ :school_id, :domain_id ]
  end
end
