class AddScheduleToSchoolYears < ActiveRecord::Migration
  def change
    add_column :school_years, :schedule, :text, :default => "[\"A\"]"
  end
end
