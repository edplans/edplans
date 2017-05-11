class CreateDomainApplications < ActiveRecord::Migration
  def change
    create_table :domain_applications do |t|
      t.integer :applicable_id
      t.string :applicable_type
      t.integer :domain_id

      t.timestamps
    end

    add_index :domain_applications, :domain_id
    add_index :domain_applications, [:applicable_type, :applicable_id]
  end
end
