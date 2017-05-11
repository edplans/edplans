class SchoolMembership < ActiveRecord::Base
  attr_accessible :school_id, :user_id, :school, :user

  belongs_to :school
  belongs_to :user

  validates_uniqueness_of :user_id
end
