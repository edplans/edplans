class Reports::CcssCoverageReportsController < ApplicationController

  def new
    @school = current_user.school
  end

  def show
    @report = CcssCoverageReport.new(params[:report].merge(:school => current_user.school))
  end

end
