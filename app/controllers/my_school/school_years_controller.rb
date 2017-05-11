class MySchool::SchoolYearsController < ApplicationController

  before_filter :require_planner
  before_filter :find_school

  def edit
    @school_year = @school.school_years.find(params[:id])
  end

  def update
    @school_year = @school.school_years.find(params[:id])
    if @school_year.update_attributes(params[:school_year])
      flash[:success] = "Your settings have been saved."
      redirect_to edit_school_year_path(@school_year)
    else
      flash[:error] = "There was a problem setting your savings."
      redirect_to edit_school_year_path(@school_year)
    end
  end

  def new
    @school_year = @school.school_years.new
  end

  def create
    @school_year = @school.school_years.new(params[:school_year])
    if @school_year.save
      flash[:success] = "This school year has been created."
      redirect_to edit_school_year_path(@school_year)
    else
      flash[:error] = "There was a problem creating this school year: <br> #{ @school_year.errors.full_messages.join('<br>') }".html_safe
      render :new
    end
  end

  def transfer
    @from = @school.school_years.find(params[:from_year_id])
    @school_year = @school.school_years.find(params[:id])
  end

  def complete_transfer
    @from = @school.school_years.find(params[:from_year_id])
    @school_year = @school.school_years.find(params[:id])
    @school_year.copy_from(@from, :grade => params[:grade],
                                  :subject_id => params[:subject_id],
                                  :include_lesson_plans => 
                                    (params[:include_lesson_plans] == 'true'))
    flash[:success] = "Your content has been copied."
    redirect_to edit_school_year_path(@school_year)
  end

  def schedule
    @school_year = @school.school_years.find(params[:id])
  end

  def update_schedule
    @school_year = @school.school_years.find(params[:id])
    @school_year.schedule = params[:school_year][:schedule].split(/,\s*/)
    @school_year.save
    flash[:success] = "Your schedule has been updated"
    redirect_to school_year_schedule_path(@school_year)
  end

end
