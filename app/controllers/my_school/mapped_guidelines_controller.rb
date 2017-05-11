class MySchool::MappedGuidelinesController < ApplicationController

  before_filter :require_planner, :find_school, :find_domain_map

  def create
    @domain_map.add_guideline!(@guideline)
    respond_to do |format|
      format.json { render :json => { :domain_id => @domain.id, :guideline_id => @guideline.id, :name => @guideline.name.html_safe, :id => @guideline.id, :draggable_text => @guideline.abbreviated_text, :custom => @guideline.custom? } }
    end
  end

  def destroy
    @domain_map.remove_guideline!(@guideline)
    respond_to do |format|
      format.json { render :json => { :success => :ok } }
    end
  end

  private

  def find_domain_map
    @domain = Domain.find(params[:domain_id])
    @guideline = Guideline.find(params[:guideline_id])
    @school_year = params[:school_year_id] ? @school.school_years.find(params[:school_year_id]) : @school.school_year
    @domain_map = @school.domain_maps.where(:domain_id => @domain.id, :school_year_id => @school_year.id).first_or_create!
  end

end
