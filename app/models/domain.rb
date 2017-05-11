class Domain < ActiveRecord::Base

  has_many :domain_applications, :dependent => :destroy
  has_many :scheduled_domains, :dependent => :destroy
  has_many :domain_maps, :dependent => :destroy
  has_many :curriculum_nodes, :through => :domain_applications, :source => :applicable, :source_type => 'CurriculumNode'
  has_many :guidelines, :through => :domain_applications, :source => :applicable, :source_type => 'Guideline'

  belongs_to :school
  scope :common, where(:school_id => nil)

  scope :for_school_with_common, lambda { |school| where("school_id = ? or school_id is ?", school.id, nil).order('school_id asc') }

  acts_as_list :scope => [:school_id, :grade]

  scope :for_grade, lambda { |grade| where(:grade => grade) }
  default_scope order('position asc')

  attr_accessible :name, :grade, :days, :tag

  attr_accessor :new_tag

  def weeks
    days.present? && days > 0 ? (days / 5.0).ceil : 1
  end

  def grade_name
    School.grade_name_for(grade)
  end

  def custom_tag
    school_id.blank? ? nil : tag
  end

  def custom_interdisciplinary?
    school_id.present? && custom_tag.blank?
  end

  def is_custom?
    school_id.present?
  end

  def is_course_unit?
    school_id.present? && tag != "Interdisciplinary"
  end

  def self.import(csv)
    csv.each do |row|
      unless row['Name'].blank?
        domain = Domain.where(:name => row['Name'].strip, :grade => row['Grade'], :school_id => nil).first_or_initialize
        domain.days = row['Days'].to_i
        domain.tag = row['Type'].try(:strip)
        domain.save
        if row['GradeOrder'].present? && row['GradeOrder'].to_i != domain.position
          domain.insert_at(row['GradeOrder'].to_i)
        end
      end
    end
  end

end
