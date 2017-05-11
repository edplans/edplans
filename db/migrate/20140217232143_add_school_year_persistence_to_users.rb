class AddSchoolYearPersistenceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_school_year_id, :integer
  end
end
