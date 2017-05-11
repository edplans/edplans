class DomainApplication < ActiveRecord::Base

  belongs_to :domain
  belongs_to :applicable, :polymorphic => true

  attr_accessible :domain_id, :applicable_id, :applicable_type

  validates_presence_of :domain_id
  validates_presence_of :applicable_id
  validates_presence_of :applicable_type

  validates_uniqueness_of :domain_id, :scope => [ :applicable_id, :applicable_type ]

  def domain_name
    domain.name
  end
  
end
