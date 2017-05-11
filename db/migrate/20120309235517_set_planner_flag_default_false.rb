class SetPlannerFlagDefaultFalse < ActiveRecord::Migration
  def up
    change_column :users, :planner, :boolean, :default => false
  end

  def down
    change_column :users, :planner, :boolean
  end
end
