module Reports::CcssCoverageReportsHelper

  def class_name_for(domain)
    return nil unless domain.present?
    if domain.custom_interdisciplinary?
      'domain-interdisciplinary'
    elsif domain.school_id.present?
      'domain-custom'
    end
  end

end
