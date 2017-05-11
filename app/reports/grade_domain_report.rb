class GradeDomainReport < ReportBase

  report_attrs :school, :grade, :style, :school_year_id

  def subjects
    school.subjects_taught
  end

  def school_year
    @school_year ||= school.school_years.find(school_year_id)
  end

  def domains_for_subject(subject)
    domains_for[subject] = scheduled_domains_for_subject(subject).map(&:domain).uniq
  end

  def scheduled_domains_for_subject(subject)
    scheduled_domains_for[subject] ||= school_year.scheduled_domains.where(:subject_id => subject.id, :grade => grade).includes(:domain).order("scheduled_domains.start_week asc, (domains.tag = 'Interdisciplinary') desc")
  end

  def weeks_taught(domain, subject)
    school_year.scheduled_domains.where(:subject_id => subject.id, :domain_id => domain.id, :grade => grade).map(&:weeks_taught).flatten.uniq.sort
  end

  private

  def domains_for
    @domains_for ||= {}
  end

  def scheduled_domains_for
    @scheduled_domains_for ||= {}
  end

end
