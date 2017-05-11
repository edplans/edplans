class CreateKnowledgeConnections < ActiveRecord::Migration
  def change
    create_table :knowledge_connections do |t|
      t.integer :guideline_id
      t.integer :prior_curriculum_node_id
      t.integer :future_curriculum_node_id

      t.timestamps
    end
    
    add_index :knowledge_connections, :guideline_id
    add_index :knowledge_connections, [ :guideline_id, :prior_curriculum_node_id ], :name => 'prior_knowledge_connections'
    add_index :knowledge_connections, [ :guideline_id, :future_curriculum_node_id ], :name => 'future_knowledge_connections'

  end
end
