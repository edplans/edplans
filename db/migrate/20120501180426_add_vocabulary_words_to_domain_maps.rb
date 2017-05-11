class AddVocabularyWordsToDomainMaps < ActiveRecord::Migration
  def change
    add_column :domain_maps, :vocabulary, :text
  end
end
