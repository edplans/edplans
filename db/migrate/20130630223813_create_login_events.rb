class CreateLoginEvents < ActiveRecord::Migration
  def change
    create_table :login_events do |t|
      t.integer :user_id
      t.integer :role

      t.timestamps
    end
    add_index :login_events, :user_id
  end
end
