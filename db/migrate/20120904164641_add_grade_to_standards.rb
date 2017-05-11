class AddGradeToStandards < ActiveRecord::Migration
  def change
    add_column :standards, :grade, :string
    add_index :standards, :grade
    add_index :standards, [ :grade, :subject ]
  end
end
