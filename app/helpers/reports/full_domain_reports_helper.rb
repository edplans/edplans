module Reports::FullDomainReportsHelper

  def class_name_for_scheduled_domain(sd)
    if sd.domain_is_course_unit?
      'domain-interdisciplinary'
    elsif sd.domain_is_custom?
      'domain-custom'
    end
  end

end
