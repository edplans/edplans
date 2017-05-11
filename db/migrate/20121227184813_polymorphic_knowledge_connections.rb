class PolymorphicKnowledgeConnections < ActiveRecord::Migration
  def up
    rename_column :knowledge_connections, :prior_curriculum_node_id, :prior_knowledge_id
    rename_column :knowledge_connections, :cross_curriculum_node_id, :cross_knowledge_id
    rename_column :knowledge_connections, :future_curriculum_node_id, :future_knowledge_id
    add_column :knowledge_connections, :prior_knowledge_type, :string
    add_column :knowledge_connections, :cross_knowledge_type, :string
    add_column :knowledge_connections, :future_knowledge_type, :string
    KnowledgeConnection.where(["prior_knowledge_id > ?", 0]).update_all(["prior_knowledge_type = ?", "CurriculumNode"])
    KnowledgeConnection.where(["cross_knowledge_id > ?", 0]).update_all(["cross_knowledge_type = ?", "CurriculumNode"])
    KnowledgeConnection.where(["future_knowledge_id > ?", 0]).update_all(["future_knowledge_type = ?", "CurriculumNode"])
  end

  def down
    rename_column :knowledge_connections, :prior_knowledge_id, :prior_curriculum_node_id
    rename_column :knowledge_connections, :cross_knowledge_id, :cross_curriculum_node_id
    rename_column :knowledge_connections, :future_knowledge_id, :future_curriculum_node_id
    remove_column :knowledge_connections, :prior_knowledge_type
    remove_column :knowledge_connections, :cross_knowledge_type
    remove_column :knowledge_connections, :future_knowledge_type
  end
end
