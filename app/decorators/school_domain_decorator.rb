class SchoolDomainDecorator < ApplicationDecorator
  decorates :domain
  allows :days, :grade, :id, :name, :position, :tag, :included

  def included?
    h.current_user.school.includes_domain?(model)
  end

  def custom?
    model.school_id.present?
  end

  def tag
    if model.custom_interdisciplinary?
      "Custom"
    else
      model.custom_tag || "Core Knowledge"
    end
  end

  def tag_class_name
    if model.custom_interdisciplinary?
      "custom"
    else
      tag.downcase.gsub(/\W+/, '-')
    end
  end

  def as_json(opts = nil)
    { :days => days, :grade => grade, :id => id, :name => name, 
      :position => position, :tag => tag, :included => included?,
      :custom => custom?, :tag_class_name => tag_class_name }
  end

end
