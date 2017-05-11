class DomainWeekReport < ReportBase

  report_attrs :school, :weeks, :include_units, :school_year_id

  def school_year
    @school_year ||= school.school_years.find(school_year_id)
  end

  def include_units?
    include_units == "true"
  end

  def grades
    school.grades
  end

  def domains_for_grade_and_week(grade, week)
    domains_for[grade][week.index]
  end

  private

  def domains_for
    @domains_for ||= grades.inject({}) do |grade_hash, grade| 
      grade_hash[grade] = weeks.inject({}) do |week_hash, week|
        week_hash[week.index] = scheduled_domains.select {|sd| sd.taught_in_week?(week.index) && sd.grade == grade}.map(&:domain)
        week_hash
      end
      grade_hash
    end
  end

  def scheduled_domains
    if include_units?
      @scheduled_domains ||= ScheduledDomain.where(:school_year_id => school_year.id).includes(:domain)
    else
      @scheduled_domains ||= ScheduledDomain.where(:school_year_id => school_year.id).includes(:domain).where(["domains.school_id is null or domains.tag = ?", "Interdisciplinary"])
    end
  end

end
