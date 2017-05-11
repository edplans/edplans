class MoveToIncludedStandardsForDomainMaps < ActiveRecord::Migration
  def up
    remove_column :domain_maps, :omitted_standard_ids
    add_column :domain_maps, :included_standard_ids, :text
    add_column :domain_maps, :included_skills_standard_ids, :text
  end

  def down
    add_column :domain_maps, :omitted_standard_ids, :text
    remove_column :domain_maps, :included_standard_ids
    remove_column :domain_maps, :included_skills_standard_ids
  end
end
