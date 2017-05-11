class LoginEvent < ActiveRecord::Base

  belongs_to :user
  attr_accessible :user

  before_save :assign_role

  ROLES = { 0 => :teacher,
            1 => :planner,
            2 => :admin }

  def role
    ROLES[read_attribute(:role)]
  end

  def role=(sym)
    write_attribute(:role, ROLES.invert[sym])
  end

  private
  
  def assign_role
    if user.admin?
      self.role = :admin
    elsif user.planner?
      self.role = :planner
    else
      self.role = :teacher
    end
  end

end
