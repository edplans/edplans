class School < ActiveRecord::Base

  has_many :school_memberships, :dependent => :destroy
  belongs_to :planner, :class_name => 'User', :conditions => {:planner => true}
  has_many :teachers, :through => :school_memberships, :source => :user
  attr_accessible :year_start, :year_end, :grades, :name

  has_many :scheduled_domains
  has_many :custom_domains, :class_name => "Domain"
  has_many :custom_standards, :class_name => "Standard"
  has_many :custom_guidelines, :class_name => "Guideline"
  has_many :domain_maps
  has_many :domain_units

  has_many :school_years
  has_many :school_holidays

  has_many :lesson_plans

  after_save :update_planner_membership

  GRADES = %w(K 1 2 3 4 5 6 7 8)
  GRADE_TRANSLATIONS = (1..8).to_a.inject({"K" => "Kindergarten"}) do |acc, i|
    acc[i.to_s] = "Grade #{ i }"
    acc
  end

  serialize :grades, JSON

  serialize :omitted_domains, JSON

  def year_start
    read_attribute(:year_start) || Date.today
  end

  def year_end
    read_attribute(:year_end) || year_start + 1.year
  end

  def grades
    # Set default grade list for new schools
    read_attribute(:grades) || write_attribute(:grades, GRADES)
  end

  def grade_translations
    grades.map {|g| GRADE_TRANSLATIONS[g]}
  end

  def grades_with_translations
    GRADE_TRANSLATIONS.select {|g,n| grades.include?(g)}
  end

  def self.inverted_grades
    GRADE_TRANSLATIONS.invert
  end

  def self.grade_name_for(abb)
    GRADE_TRANSLATIONS[abb]
  end

  def school_year(date = Date.today)
    @school_year ||= SchoolYear.year_for_school_and_date(self, date)
  end

  def subjects_taught
    CurriculumNode.roots.order('position asc').all
  end

  def omitted_domains
    read_attribute(:omitted_domains) || []
  end

  def includes_domain?(domain)
    !omitted_domains.include?(domain.id)
  end

  def omit_domain!(domain)
    if includes_domain?(domain)
      update_attribute(:omitted_domains, omitted_domains << domain.id)
    end
  end

  def include_domain!(domain)
    unless includes_domain?(domain)
      update_attribute(:omitted_domains, omitted_domains - [domain.id])
    end
  end

  def custom_domain_tags
    custom_domains.map(&:tag).reject(&:blank?).uniq - ["Interdisciplinary"]
  end

  private

  def update_planner_membership
    return unless planner_id.present?
    school_memberships.where(:user_id => planner_id).first_or_create!.update_attribute :school_id, id
  end

end
