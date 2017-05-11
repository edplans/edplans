class MySchoolController < ApplicationController

  before_filter :require_planner, :except => [ :show_curriculum, :show_domain_map ]
  before_filter :find_school

  def plan
    @grade = params[:grade]
    @grade_name = School.grade_name_for(@grade)
    @tags = @school.custom_domain_tags
    school_year
    @subjects = CurriculumNode.roots.order('position asc')
  end

  def domains
    @domains = SchoolDomainDecorator.decorate(Domain.common.where(:grade => params[:grade]) + @school.custom_domains.where(:grade => params[:grade]))
    respond_to do |format|
      format.json { render :json => @domains }
    end
  end

  def scheduled_domains
    @scheduled_domains = school_year.scheduled_domains.where(:grade => params[:grade]).includes(:subject)
    respond_to do |format|
      format.json { render :json => @scheduled_domains }
    end
  end

  def update
    if @school.update_attributes(params[:school])
      flash[:success] = "Your changes have been saved."
    else
      flash[:error] = "There was a problem saving your changes."
    end
    redirect_to edit_my_school_path
  end

  private

  def school_year
    @school_year ||= if params[:school_year_id]
                       current_user.update_attribute :last_school_year_id, params[:school_year_id]
                       @school.school_years.find(params[:school_year_id])
                     elsif current_user.last_school_year_id
                       @school.school_years.find(current_user.last_school_year_id) rescue @school.school_year
                     else
                       @school.school_year
                     end
  end

end
