class Reports::RelatedKnowledgeReportsController < ApplicationController

  def new
    @school = current_user.school
  end

  def show
    params[:report][:domain] = Domain.find(params[:report].delete(:domain_id))
    @report = RelatedKnowledgeReport.new(params[:report].merge(:teacher => current_user))
  end

end
