class Admin::GuidelineStandardApplicationsController < ApplicationController

  before_filter :require_admin

  def create
    @guideline = Guideline.find(params[:guideline_id])
    @application = @guideline.standard_applications.create(params[:guideline_standard_application])
    respond_to do |format|
      format.json { render :json => @application.to_json(:methods => [ :id, :standard_text, :standard_short_text, :standard_ck_code, :standard_id ]) }
    end
  end

  def destroy
    @guideline = Guideline.find(params[:guideline_id])
    @application = @guideline.standard_applications.find(params[:id])
    @application.destroy
    respond_to do |format|
      format.json { render :json => @application }
    end
  end
    
end
