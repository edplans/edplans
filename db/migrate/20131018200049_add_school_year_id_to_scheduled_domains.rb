class AddSchoolYearIdToScheduledDomains < ActiveRecord::Migration
  def change
    add_column :scheduled_domains, :school_year_id, :integer
    add_index :scheduled_domains, :school_year_id
  end
end
