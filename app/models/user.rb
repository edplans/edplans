class User < ActiveRecord::Base

  authenticates_with_sorcery!

  scope :by_token, lambda { |token| where(:invitation_token => token) }

  before_save :reset_invitation_token_on_acceptance

  has_one :school_membership, :dependent => :destroy
  has_one :school, :through => :school_membership

  has_many :domain_units, :foreign_key => :teacher_id, :dependent => :destroy
  has_many :lesson_plans, :foreign_key => :teacher_id, :dependent => :destroy

  attr_accessible :first_name, :last_name, :terms

  validates_uniqueness_of :email
  validates_acceptance_of :terms, :message => "You must accept the terms of use to use this software."

  def self.generate_invitation_token
    SecureRandom.base64(8).gsub("/","_").gsub(/=+$/,"")
  end

  def self.authenticate(*credentials)
    user = super(*credentials)
    user.try(:active?) ? user : nil
  end

  def name
    [first_name, last_name].compact.join(' ')
  end

  def name_or_email
    name.blank? ? email : name
  end

  def teacher?
    read_attribute(:teacher) || planner?
  end

  def send_invitation_email
    InvitationsMailer.invitation(self).deliver
  end

  def send_new_school_invitation_email
    InvitationsMailer.invitation_for_new_school(self).deliver
  end

  private

  def reset_invitation_token_on_acceptance
    if changed.include?('crypted_password') && invitation_token.present?
      self.invitation_token = nil
    end
  end

end
