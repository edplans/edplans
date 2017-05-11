class Teachers::ScheduledLessonPlansController < ApplicationController

  def create
    @slp = ScheduledLessonPlan.for_teacher_and_school_year(teacher, school_year).create(params[:scheduled_lesson_plan])
    respond_to do |format|
      format.json { render :json => ScheduledLessonPlanDecorator.decorate(@slp) }
    end
  end

  private

  def teacher
    @teacher ||= current_user
  end

  def school_year
    @school_year ||= teacher.school.school_years.find(params[:school_year_id])
  end

end
