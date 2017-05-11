class SsCoverageReport < ReportBase

  report_attrs :school, :subject_id, :grade, :include_only, :school_year_id

  def school_year
    @school_year ||= school.school_years.find(school_year_id)
  end

  def grades
    grade.present? ? [grade] : school.grades
  end

  def subject
    @subject ||= CurriculumNode.find(subject_id)
  end

  def guideline_covered?(guideline)
    domain_maps.any? {|d| d.has_guideline?(guideline)}
  end

  def domains_for(guideline)
    domain_maps.select {|d| d.has_guideline?(guideline)}.map(&:domain)
  end

  def start_week_for(domain)
    school_year.scheduled_domains.where(:domain_id => domain.id).first.try(:start_week)
  end

  def include_covered?
    @include_only != "unplanned"
  end

  def include_uncovered?
    @include_only != "planned"
  end

  private

  def domain_maps
    @domain_maps ||= school_year.domain_maps
  end

end
