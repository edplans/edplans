class Teachers::CalendarController < ApplicationController

  before_filter :assign_school_year, :require_teacher

  def show
    @domain_units = @school_year.domain_maps.map(&:domain_units).flatten
    @lesson_plans = @domain_units.map {|u| u.lesson_plans.for_teacher(current_user) }.flatten
  end

  def events
    start_date = Time.at(params[:start].to_i).to_datetime
    end_date = Time.at(params[:end].to_i).to_datetime
    respond_to do |format|
      format.json { render :json => (SchoolHolidayDecorator.decorate(school_holidays(start_date, end_date)).as_json + teaching_schedule_days(start_date, end_date) + ScheduledLessonPlanDecorator.decorate(scheduled_lesson_plans(start_date, end_date))) }
    end
  end

  def persist_month
    session[:persisted_months] ||= {@school_year.id => {}}
    session[:persisted_months][@school_year.id] = params[:month_fragment]
    render :json => { :stored => :ok }
  end

  private

  def scheduled_lesson_plans(start_date, end_date)
    @slps ||= ScheduledLessonPlan.for_teacher_and_school_year(current_user, @school_year).includes(:lesson_plan).where("date >= ? and date <= ?", start_date, end_date)
  end
  
  def school_holidays(start_date, end_date)
    school.school_holidays.where("start_date >= ? and start_date <= ?", start_date, end_date)
  end

  def school
    @school ||= current_user.school
  end

  def teaching_schedule_days(start_date, end_date)
    school_year = school.school_year(start_date)
    start_i = school_year.days_count_before(start_date)
    schedule = school.school_year.schedule
    holidays = school_holidays(start_date, end_date)
    (start_date..end_date).
      to_a.
      select { |d| d.wday != 0 && d.wday != 6 && holidays.find {|h| h.start_date == d.to_date }.blank?}.
      map.with_index { |d, i| { :start => d, :title => schedule[(i + start_i) % schedule.size] } }
  end

  def assign_school_year
    @school_year ||= if params[:school_year_id]
                       current_user.update_attribute :last_school_year_id, params[:school_year_id]
                       school.school_years.find(params[:school_year_id])
#                     Wait on this for now
#                     elsif current_user.last_school_year_id
#                       school.school_years.find(current_user.last_school_year_id)
                     elsif params[:start]
                       school.school_year(Time.at(params[:start].to_i).to_datetime)
                     else
                       school.school_year
                     end
  end

end
