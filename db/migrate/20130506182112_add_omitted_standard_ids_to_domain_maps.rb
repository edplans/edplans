class AddOmittedStandardIdsToDomainMaps < ActiveRecord::Migration
  def change
    add_column :domain_maps, :omitted_standard_ids, :text
    add_column :domain_maps, :omitted_skills_standard_ids, :text
  end
end
