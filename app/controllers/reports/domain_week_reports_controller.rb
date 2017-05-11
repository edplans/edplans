class Reports::DomainWeekReportsController < ApplicationController

  def new
    @school = current_user.school
  end

  def show
    @school = current_user.school
    if params[:report][:week].blank?
      weeks = @school.school_year.weeks
    else
      week_index = params[:report].delete(:week).to_i
      weeks = @school.school_year.weeks.select {|w| w.index == week_index}
    end
    @report = DomainWeekReport.new(:school => @school, :weeks => weeks, :school_year_id => params[:report][:school_year_id])
  end

end
