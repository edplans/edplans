class Guideline < ActiveRecord::Base

  belongs_to :curriculum_node

  has_many :domain_applications, :as => :applicable, :dependent => :destroy
  has_many :domains, :through => :domain_applications

  has_many :standard_applications, :dependent => :destroy
  has_many :standards, :through => :standard_applications

  has_many :sub_guidelines

  has_many :knowledge_connections

  has_many :prior_knowledge_curriculum_nodes, :through => :knowledge_connections, :source => :prior_knowledge, :source_type => 'CurriculumNode'
  has_many :future_knowledge_curriculum_nodes, :through => :knowledge_connections, :source => :future_knowledge, :source_type => 'CurriculumNode'
  has_many :cross_knowledge_curriculum_nodes, :through => :knowledge_connections, :source => :cross_knowledge, :source_type => 'CurriculumNode'
  has_many :prior_knowledge_guidelines, :through => :knowledge_connections, :source => :prior_knowledge, :source_type => 'Guideline'
  has_many :future_knowledge_guidelines, :through => :knowledge_connections, :source => :future_knowledge, :source_type => 'Guideline'
  has_many :cross_knowledge_guidelines, :through => :knowledge_connections, :source => :cross_knowledge, :source_type => 'Guideline'

  attr_accessible :name, :notes, :school_id, :curriculum_node_id

  scope :common, lambda { where(:school_id => nil) }
  scope :for_school, lambda { |school|
    where(:school_id => [nil, school.id])
  }

  def prior_knowledge_connections
    prior_knowledge_guidelines + prior_knowledge_curriculum_nodes
  end

  def cross_knowledge_connections
    cross_knowledge_guidelines + cross_knowledge_curriculum_nodes
  end

  def future_knowledge_connections
    future_knowledge_guidelines + future_knowledge_curriculum_nodes
  end
  
  def position
    id
  end

  def abbreviated_text
    name.size > 30 ? "#{ name[0..27] }..." : name
  end

  def inherited_domains
    (curriculum_node.inherited_domains + domains).flatten.uniq
  end

  def name_with_prefix
    name
  end

  def grade_name
    curriculum_node.grade_name
  end

  def grade
    curriculum_node.grade
  end

  def custom?
    school_id.present?
  end

end
