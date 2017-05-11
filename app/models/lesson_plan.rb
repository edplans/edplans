class LessonPlan < ActiveRecord::Base

  belongs_to :school
  belongs_to :teacher, :class_name => 'User'
  belongs_to :domain_unit

  belongs_to :copied_from, :class_name => 'LessonPlan'
  has_many :copies_of, :class_name => 'LessonPlan', :foreign_key => :copied_from_id

  has_many :lesson_plan_files

  attr_protected :school_id

  before_create :set_school

  scope :for_teacher, lambda { |teacher| where(:teacher_id => teacher.id) }
  scope :for_domain_map, lambda { |domain_map| where(:domain_map_id => domain_map.id) }

  scope :public_or_owned_by, lambda { |t| where('shared = ? or teacher_id = ?', true, t.id) }

  serialize :measurable_objectives, JSON
  serialize :guidelines_included, JSON
  serialize :checked_sub_guidelines, JSON

  validates_presence_of :teacher

  def self.field_names
    @@field_names ||= [ :description, :essential_understanding, :vocabulary_tier_2_words, :read_aloud_resources, :materials_and_resources, :procedures, :extensions, :support_and_enrichment, :ongoing_assessment, :criteria_for_success ]
  end

  def self.clone(old_plan)
    new.tap do |new_plan|
      new_plan.copied_from_id = old_plan.id
      new_plan.domain_unit = old_plan.domain_unit
      new_plan.name = old_plan.name
      new_plan.school = old_plan.school
      new_plan.measurable_objectives = old_plan.measurable_objectives
      new_plan.checked_sub_guidelines = old_plan.checked_sub_guidelines
      field_names.each do |field_name|
        new_plan.send("#{field_name}=", old_plan.send(field_name))
      end
    end
  end

  def self.labels
    @@labels ||= { :read_aloud_resources => "Read-Aloud", :ongoing_assessment => "Assessment", :vocabulary_tier_2_words => "My Vocabulary Words", :team_notes => "Creator's Notes to Other Users" }
  end

  def self.label_text_for(field_name)
    labels[field_name] || field_name.to_s.titleize
  end

  def owned_by?(user)
    teacher == user
  end

  def copied?
    copied_from_id.present?
  end

  def measurable_objectives
    read_attribute(:measurable_objectives) || {}
  end

  def measurable_objective_for(guideline)
    measurable_objectives[guideline.id.to_s]
  end

  def guidelines_included
    read_attribute(:guidelines_included).try(:keys).try(:map, &:to_i) || []
  end

  def includes_guideline?(guideline)
    guidelines_included.include?(guideline.id)
  end

  def siblings_which_cover_guideline(guideline)
    domain_unit.lesson_plans.select {|l| l.id != id && l.includes_guideline?(guideline)}
  end

  def checked_sub_guidelines
    read_attribute(:checked_sub_guidelines) || []
  end

  def sub_guideline_checked?(sub_guideline)
    checked_sub_guidelines.include?(sub_guideline.id)
  end

  def check_sub_guideline!(sub_guideline)
    self.checked_sub_guidelines = (checked_sub_guidelines << sub_guideline.id).uniq
    save!
  end

  def uncheck_sub_guideline!(sub_guideline)
    self.checked_sub_guidelines = (checked_sub_guidelines - [sub_guideline.id])
    save!
  end

  def domain_map
    @domain_map ||= domain_unit.domain_map
  end

  def domain_id
    domain_map.domain_id
  end

  def subject_guidelines
    domain_map && domain_map.guidelines.select { |g| includes_guideline? g }
  end

  def skills_guidelines
    domain_map && domain_map.skills_guidelines.select { |g| includes_guideline? g }
  end

  def cross_curriculum_connections
    domain_map && domain_map.cross_curriculum_connections
  end

  def prior_knowledge_connections
    domain_map && domain_map.prior_knowledge_connections
  end

  def future_knowledge_connections
    domain_map && domain_map.future_knowledge_connections
  end

  def domain_vocabulary
    domain_map && domain_map.vocabulary
  end

  private

  def set_school
    self.school = self.teacher.school if self.school.nil?
  end

end
