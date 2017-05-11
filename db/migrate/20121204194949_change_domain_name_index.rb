class ChangeDomainNameIndex < ActiveRecord::Migration
  def up
    remove_index :domains, :name
    add_index :domains, :name
  end

  def down
    remove_index :domains, :name
    add_index :domains, :name, :unique => true
  end
end
