class CreateSchoolHolidays < ActiveRecord::Migration
  def change
    create_table :school_holidays do |t|
      t.integer :school_id
      t.date :start_date
      t.date :end_date
      t.string :name

      t.timestamps
    end

    add_index :school_holidays, :school_id
  end
end
