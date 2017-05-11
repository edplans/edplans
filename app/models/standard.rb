class Standard < ActiveRecord::Base

  has_many :standard_applications, :dependent => :destroy
  has_many :guidelines, :through => :standard_applications

  after_save :clear_cache
  after_destroy :clear_cache

  before_create :set_grade

  validates_presence_of :ck_code, :unless => :school_id
  validates_presence_of :subject
  validates_presence_of :text
  validates_presence_of :grade

  acts_as_list :scope => 'origin = #{ origin.present? ? ("\'" + origin + "\'") : "null" }'

  default_scope order('position asc')

  scope :common, -> { where(:school_id => nil) }
  scope :for_grade, lambda { |grade|
    where(:grade => grade)
  }
  scope :for_school, lambda { |school|
    where(:school_id => school.id)
  }
  scope :for_school_or_common, lambda { |school|
    where(:school_id => [nil, school.id])
  }
  scope :for_subject, lambda { |subject|
    where(:subject => subject)
  }

  attr_accessible :grade, :subject, :ck_code, :text, :ck_align, :strand_code, :strand, :category

  def short_text
    short_text = text.size > 40 ? text[0..37] + "..." : text
    short_text.gsub(/<\/?\w+>?/, '')
  end

  def grade_name
    School::GRADE_TRANSLATIONS[grade]
  end

  private

  def clear_cache
    Rails.cache.delete("ccss_standards_json")
  end

  def set_grade
    self.grade = ck_code.split('.').first unless grade.present?
  end

  def self.import(csv)
    csv.each do |row|
      origin = row["Source"] || "CCSS"
      unless row["ckCode"].blank?
        grades = row["ckCode"].split('.').first.split('-')
        if grades.size > 1
          grades = Range.new(*grades.map(&:to_i)).to_a.map &:to_s
        end
        grades.each do |grade|
          standard = Standard.where(:origin => origin, :position => row['ckOrder']).first_or_initialize
          standard.grade = grade
          standard.subject = row["Subject"]
          standard.ck_code = grade + "." + row["ckCode"].split(".", 2).last
          standard.ck_align = row["ckAlignCode"]
          standard.strand_code = row["StrandCode"]
          standard.strand = row["Strand/Domain"]
          standard.category = row["Category/Cluster"]
          standard.text = row["CCSS Standard"] || row["Standard"] || row["Standard Text"]
          standard.save
        end
      end
    end
  end

  def self.subjects_for_grade(grade)
    unscoped.common.for_grade(grade).select('distinct subject').map(&:subject)
  end

  def self.custom_subjects_for_grade(school, grade)
    unscoped.for_school(school).for_grade(grade).select('distinct subject').map(&:subject)
  end

end
