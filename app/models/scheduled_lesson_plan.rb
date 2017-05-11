class ScheduledLessonPlan < ActiveRecord::Base
  attr_accessible :date, :lesson_plan_id

  belongs_to :teacher, :class_name => "User"
  belongs_to :school_year
  belongs_to :lesson_plan

  scope :for_teacher_and_school_year, lambda { |teacher, school_year| where(:teacher_id => teacher.id, :school_year_id => school_year.id) }

  def lesson_plan_name
    lesson_plan.name
  end

end
