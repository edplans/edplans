class Reports::FullDomainReportsController < ApplicationController

  def new
    @school = current_user.school
  end

  def show
    @school = current_user.school
    @report = FullDomainReport.new(params[:report].merge(:school => @school))
  end

end
