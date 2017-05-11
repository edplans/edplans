class CurriculumNode < ActiveRecord::Base

  has_ancestry :cache_depth => true
  acts_as_list :scope => 'ancestry = #{ ancestry.present? ? ("\'" + ancestry + "\'") : "null" }'

  has_many :guidelines, :dependent => :destroy
  has_many :domain_applications, :as => :applicable
  has_many :domains, :through => :domain_applications

  has_many :scheduled_domains, :foreign_key => :subject_id, :dependent => :destroy

  attr_accessible :name, :notes, :ancestry

  def inherited_domains
    @inherited_domains ||= (self.ancestors.includes(:domain_applications => :domain).all.map(&:domains) + domains).flatten.uniq
  end

  LEVEL_NAMES = ["Subject Area", "Grade Level", "Unit", "Topic"]
  PREFIXES = Hash.new([]).merge({
    "Unit" => %w(I II III IV V VI VII VIII IX X),
    "Topic" => %w(A B C D E F G H I J K L M N)
  })

  def level_name
    @level_name ||= LEVEL_NAMES[depth]
  end

  def next_level_name
    @next_level_name ||= LEVEL_NAMES[depth + 1]
  end

  def name_with_prefix
    PREFIXES[level_name].present? ? "#{ PREFIXES[level_name][position - 1] }. #{ name }" : name
  end

  def grade_name
    if ancestry_depth == 1
      name
    else
      ancestors.at_depth(1).first.name
    end
  end

  def grade
    School.inverted_grades[grade_name]
  end

  def subtree_for_grade(grade)
    return [] unless grade_level = children.where(:name => grade).first
    tree = grade_level.subtree.arrange(:include => :domain_applications)[grade_level]
  end

  def children_for_grade(grade)
    name = School.grade_name_for(grade) || grade
    child = children.where(:name => name).first
    child.children.order('position asc') if child
  end

  def self.import(csv)
    current_item, current_node, current_subject_area, current_grade_level, current_unit, current_topic, current_guideline = nil

    ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')

    csv.each do |row|
      if row["Subject Area"].present?
        current_item = current_node = current_subject_area = CurriculumNode.roots.where(:name => ic.iconv(row["Subject Area"])).first_or_create!
      elsif row["Grade Level"].present?
        current_item = current_node = current_grade_level = current_subject_area.children.where(:name => ic.iconv(row["Grade Level"]).gsub(/^\w*\. /, "")).first_or_create!
      elsif row["Unit"].present?
        current_item = current_node = current_unit = current_grade_level.children.where(:name => ic.iconv(row["Unit"]).gsub(/^\w*\. /, "")).first_or_create!
      elsif row["Topic"].present?
        current_item = current_node = current_topic = current_unit.children.where(:name => ic.iconv(row["Topic"]).gsub(/^\w*\. /, "")).first_or_create!
      elsif row["Guideline"].present?
        current_item = current_guideline = current_node.guidelines.where(:name => ic.iconv(row["Guideline"]).gsub(/^\W*/, "")).first_or_create!
      end
      if row["CCSS Standard"].present?
        if standard = Standard.where(:ck_code => row["CCSS Standard"]).first
          current_guideline.standards << standard unless current_guideline.standards.include?(standard)
        end
      end
      if row["Notes"].present?
        current_item.update_attribute(:notes, ic.iconv(row["Notes"]))
      end
      if row["Sub-Guideline"].present?
        current_guideline.sub_guidelines.where(:name => ic.iconv(row["Sub-Guideline"])).first_or_create!
      end

      #      TODO: Figure out how to handle 'Sub-Guideline' nonsense
      #
      #      if row["Sub-Guideline"].present?
      #        current_guideline.content ||= ""
      #        current_guideline.content << row["Sub-Guideline"] << "\n"
      #        current_guideline.save
      #      end
      %w(Domain1 Domain2 Domain3).each do |column|
        if row[column].present? && row[column].strip != "{none}"
          current_item.domains << Domain.common.where(:name => row[column].strip, :grade => School.inverted_grades[current_grade_level.name]).first_or_create!
        end
      end
    end
  end

end
