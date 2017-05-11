class AddSkillsGuidelinesToDomainMaps < ActiveRecord::Migration
  def change
    add_column :domain_maps, :skills_guideline_ids, :text
  end
end
