class ScheduledLessonPlanDecorator < ApplicationDecorator

  decorates :scheduled_lesson_plan

  def as_json(opts = {})
    { :start => model.date,
      :title => model.lesson_plan_name }
  end

end
