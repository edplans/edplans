class DomainUnit < ActiveRecord::Base
  
  belongs_to :domain_map
  belongs_to :teacher, :class_name => 'User'
  belongs_to :subject, :class_name => 'CurriculumNode'
  belongs_to :school
  has_many :lesson_plans, :dependent => :destroy

  scope :for_domain_map, lambda { |m| where(:domain_map_id => m.id) }

  attr_accessible :name, :subject_id

end
