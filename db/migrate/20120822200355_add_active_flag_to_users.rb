class AddActiveFlagToUsers < ActiveRecord::Migration
  def up
    add_column :users, :active, :boolean, :default => true
    User.update_all ['active = ?', true]
  end
  
  def down
    remove_column :users, :active
  end
end
