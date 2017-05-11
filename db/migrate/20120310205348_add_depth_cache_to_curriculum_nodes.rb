class AddDepthCacheToCurriculumNodes < ActiveRecord::Migration
  def change
    add_column :curriculum_nodes, :ancestry_depth, :integer, :default => 0
  end
end
