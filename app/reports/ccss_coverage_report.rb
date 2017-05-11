class CcssCoverageReport < ReportBase

  report_attrs :school, :grade, :subject, :include_only, :school_year_id

  def school_year
    @school_year ||= school.school_years.find(school_year_id)
  end

  def grades
    grade.present? ? [grade] : school.grades
  end

  def subject_name
    {"ELA" => "ELA/Literacy", "Math" => "Math"}[subject]
  end

  def strands_for_grade(grade)
    standards = Standard.unscoped.for_school_or_common(school).where(:grade => grade).select('position, strand').order('position asc')
    standards = standards.where(:subject => subject) unless subject.blank?
    standards.map(&:strand).uniq
  end

  def categories_for_grade_and_strand(grade, strand)
    standards = Standard.unscoped.for_school_or_common(school).where(:grade => grade, :strand => strand).select('position, category').order('position asc')
    standards = standards.where(:subject => subject) unless subject.blank?
    standards.map(&:category).uniq
  end

  def standards_for_grade_strand_and_category(grade, strand, category)
    standards = Standard.for_school_or_common(school).where(:grade => grade, :strand => strand, :category => category).order('position asc')
    standards = standards.where(:subject => subject) unless subject.blank?
    standards
  end

  def domain_maps_for_grade(grade)
    @domain_maps ||= {}
    @domain_maps[grade] ||= begin
#                              domains = Domain.where(:grade => grade)
                              DomainMap.where(:school_year_id => school_year.id, :domains => { :grade => grade }).includes(:domain)
                            end
  end

  def domain_maps_with_standard_taught(standard, grade)
    domain_maps_for_grade(grade).select do |map|
      map.included_standards.include?(standard) ||
        map.included_skills_standards.include?(standard)
    end.compact.reject {|d| d.scheduled_domain.nil?}.sort_by(&:start_week)
  end

  def include_planned?
    @include_only != "unplanned"
  end

  def include_unplanned?
    @include_only != "planned"
  end

end
