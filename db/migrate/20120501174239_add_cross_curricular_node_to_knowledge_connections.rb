class AddCrossCurricularNodeToKnowledgeConnections < ActiveRecord::Migration
  def change
    add_column :knowledge_connections, :cross_curriculum_node_id, :integer
    add_index :knowledge_connections, [ :guideline_id, :cross_curriculum_node_id ], :name => 'cross_curricular_connections'
  end
end
