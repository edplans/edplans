class Reports::SubjectDomainReportsController < ApplicationController

  include ReportsHelper

  def new
    @school = current_user.school
  end

  def show
    style = params[:report].delete(:style).underscore
    if style == 'timeline' && params[:format] == 'pdf'
      flash[:error] = "That combination is not currently available."
      redirect_to new_subject_domain_report_path(:format => :html)
    else
      @report = SubjectDomainReport.new(params[:report].merge(:school => current_user.school))
      render style
    end
  end

end
