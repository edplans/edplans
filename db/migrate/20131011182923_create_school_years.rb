class CreateSchoolYears < ActiveRecord::Migration
  def change
    create_table :school_years do |t|
      t.integer :school_id
      t.date :start_date
      t.date :end_date
      t.string :name

      t.timestamps
    end
    add_index :school_years, :school_id
  end
end
