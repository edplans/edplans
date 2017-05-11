class AddOmittedStandardsToDomainMaps < ActiveRecord::Migration
  def change
    add_column :domain_maps, :omitted_standard_ids, :text
  end
end
