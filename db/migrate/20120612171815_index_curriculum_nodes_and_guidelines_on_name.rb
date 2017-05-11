class IndexCurriculumNodesAndGuidelinesOnName < ActiveRecord::Migration
  def change
    add_index :curriculum_nodes, :name
    add_index :guidelines, :name
  end
end
