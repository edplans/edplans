class Reports::DomainLessonsReportsController < ApplicationController

  def new
    @school = current_user.school
  end

  def show
    params[:report][:domain] = Domain.find(params[:report].delete(:domain_id))
    @report = DomainLessonsReport.new(params[:report].merge(:teacher => current_user))
  end

end
