class KnowledgeConnection < ActiveRecord::Base

  attr_accessible :prior_knowledge, :prior_knowledge_id, :prior_knowledge_type, :cross_knowledge, :cross_knowledge_id, :cross_knowledge_type, :future_knowledge, :future_knowledge_id, :future_knowledge_type, :guideline

  belongs_to :guideline
  belongs_to :prior_knowledge, :polymorphic => true
  belongs_to :future_knowledge, :polymorphic => true
  belongs_to :cross_knowledge, :polymorphic => true

  validates_presence_of :guideline

  def as_json(opts = {})
    { :id => id, :guideline_id => guideline_id, :prior_knowledge_id => prior_knowledge_id, :future_knowledge_id => future_knowledge_id, :cross_knowledge_id => cross_knowledge_id, :name => name, :connection_type => connection_type, :connection_id => connection_id, :grade => grade }
  end

  def connection_type
    prior_knowledge_type || cross_knowledge_type || future_knowledge_type
  end

  def connection_id
    prior_knowledge_id || cross_knowledge_id || future_knowledge_id
  end

  def name
    return unless connection = prior_knowledge || future_knowledge || cross_knowledge
    "#{ connection.name_with_prefix } (#{ connection.grade_name })"
  end

  def grade
    return unless connection = prior_knowledge || future_knowledge || cross_knowledge
    connection.grade
  end

  class ExactlyOneCurriculumNodeValidator < ActiveModel::Validator
    def validate(record)
      if record.prior_knowledge_id.blank? && 
          record.future_knowledge_id.blank? &&
          record.cross_knowledge_id.blank?
        record.errors[:base] = "You must add a curriculum connection"
      elsif [ record.prior_knowledge_id,
          record.future_knowledge_id, record.cross_knowledge_id ].compact.size > 1
        record.errors[:base] = "You must add only one curriculum connection"
      end
    end
  end
  validates_with ExactlyOneCurriculumNodeValidator

end
