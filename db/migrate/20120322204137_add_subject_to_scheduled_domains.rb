class AddSubjectToScheduledDomains < ActiveRecord::Migration
  def change
    add_column :scheduled_domains, :subject_id, :integer
  end
end
