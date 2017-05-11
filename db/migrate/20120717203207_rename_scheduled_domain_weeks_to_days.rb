class RenameScheduledDomainWeeksToDays < ActiveRecord::Migration
  def up
    rename_column :scheduled_domains, :weeks, :days
  end

  def down
    rename_column :scheduled_domains, :days, :weeks
  end
end
