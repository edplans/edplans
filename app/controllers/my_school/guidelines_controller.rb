class MySchool::GuidelinesController < ApplicationController

  before_filter :require_planner, :find_school

  def destroy
    @guideline = @school.custom_guidelines.find(params[:id])
    if @guideline.destroy
      respond_to do |format|
        format.html { redirect_to request.referer }
        format.json { render :json => { :success => :ok } }
      end
    end
  end

  def create
    @guideline = @school.custom_guidelines.create(params[:guideline])
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.json { render :json => @guideline }
    end
  end

  def update
    @guideline = @school.custom_guidelines.find(params[:id])
    @guideline.update_attributes(params[:guideline])
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.json { render :json => @guideline }
    end
  end

end
