class LessonPlanDecorator < ApplicationDecorator

  def as_json(opts = {})
    { :name => name, :teacher_name => model.teacher.name, :owned => (model.teacher == h.current_user), :id => id, :domain_unit_id => domain_unit_id, :domain_id => model.domain_unit.domain_map.domain_id, :created_at => created_at }
  end

end
