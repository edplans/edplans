class CreateSchoolMemberships < ActiveRecord::Migration
  def change
    create_table :school_memberships do |t|
      t.integer :user_id
      t.integer :school_id

      t.timestamps
    end

    add_index :school_memberships, :user_id, :unique => true
    add_index :school_memberships, :school_id
  end
end
