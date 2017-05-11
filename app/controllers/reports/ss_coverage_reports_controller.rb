class Reports::SsCoverageReportsController < ApplicationController

  include ReportsHelper

  def new
    @school = current_user.school
  end

  def show
    @school = current_user.school
    @report = SsCoverageReport.new(params[:report].merge(:school => @school))
  end

end
