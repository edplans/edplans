class AddOmittedCrossCurricularLinksToDomainMaps < ActiveRecord::Migration
  def change
    add_column :domain_maps, :omitted_cross_curricular_links, :text
  end
end
