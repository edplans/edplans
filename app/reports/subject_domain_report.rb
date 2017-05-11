class SubjectDomainReport < ReportBase

  report_attrs :school, :subject_id, :style, :include_units, :school_year_id

  def grades
    school.grades
  end

  def school_year
    @school_year ||= school.school_years.find(school_year_id)
  end

  def include_units?
    include_units == "true"
  end

  def subject
    @subject ||= CurriculumNode.find(subject_id)
  end

  def domains_for_grade(grade)
    domains_for[grade] ||= scheduled_domains_for_grade(grade).map(&:domain)
  end

  def scheduled_domains_for_grade(grade)
    if include_units?
      scheduled_domains_for[grade] ||= school.scheduled_domains.where(:subject_id => subject.id, :grade => grade, :school_year_id => school_year.id).includes(:domain).order("scheduled_domains.start_week asc, (domains.tag = 'Interdisciplinary') desc")
    else
      scheduled_domains_for[grade] ||= school.scheduled_domains.where(:subject_id => subject.id, :grade => grade, :school_year_id => school_year.id).where(["domains.school_id is null or domains.tag = ?", "Interdisciplinary"]).includes(:domain).order("scheduled_domains.start_week asc, (domains.tag = 'Interdisciplinary') desc")
    end
  end

  def weeks_taught(domain, grade)
    scheduled_domains_for_grade(grade).select {|s| s.domain == domain}.map(&:weeks_taught).flatten.uniq
  end

  private

  def scheduled_domains_for
    @scheduled_domains_for ||= {}
  end

  def domains_for
    @domains_for ||= {}
  end

end
