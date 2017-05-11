class Admin::GuidelineDomainApplicationsController < ApplicationController

  before_filter :require_admin

  def create
    @guideline = Guideline.find(params[:guideline_id])
    @application = @guideline.domain_applications.create(params[:guideline_domain_application])
    respond_to do |format|
      format.json { render :json => @application.to_json(:methods => [ :id, :domain_name ]) }
    end
  end

  def destroy
    @guideline = Guideline.find(params[:guideline_id])
    @application = @guideline.domain_applications.find(params[:id])
    @application.destroy
    respond_to do |format|
      format.json { render :json => @application }
    end
  end
    
end
