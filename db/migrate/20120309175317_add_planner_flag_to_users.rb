class AddPlannerFlagToUsers < ActiveRecord::Migration
  def change
    add_column :users, :planner, :boolean
  end
end
