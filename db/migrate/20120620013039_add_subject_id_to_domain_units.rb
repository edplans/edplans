class AddSubjectIdToDomainUnits < ActiveRecord::Migration
  def change
    add_column :domain_units, :subject_id, :integer
  end
end
