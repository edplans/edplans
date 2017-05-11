class DomainUnitDecorator < ApplicationDecorator

  decorates :domain_unit

  allows :domain_map_id, :domain_id, :teacher_id, :subject_id, 
  :subject_name, :id, :name, :lesson_plans

  def owned?
    h.current_user == model.teacher
  end

  def lesson_plans_empty?
    model.lesson_plans.empty?
  end

  def subject_name
    model.subject && model.subject.name
  end

  def lesson_plans
    LessonPlanDecorator.decorate(model.lesson_plans.public_or_owned_by(h.current_user))
  end

  def as_json(opts = {})
    { :domain_map_id => domain_map_id, :domain_id => model.domain_map.domain_id, :teacher_id => teacher_id, :subject_id => subject_id, :subject_name => subject_name, :id => id, :name => name, :lesson_plans => lesson_plans, :owned => owned?, :lesson_plans_empty => lesson_plans_empty? }
  end

end
