class Teachers::LessonPlansController < ApplicationController

  def show
    @lesson_plan = domain_unit.lesson_plans.find(params[:id])
  end

  def edit
    @lesson_plan = domain_unit.lesson_plans.for_teacher(current_user).find(params[:id])
  end

  def new
    @lesson_plan = domain_unit.lesson_plans.new
  end

  def clone
    @old_plan = domain_unit.lesson_plans.find(params[:id])
    @lesson_plan = LessonPlan.clone(@old_plan).tap do |l|
      l.teacher = current_user
      l.school = current_user.school
    end
    @school_year = domain_unit.domain_map.school_year
    if @lesson_plan.save
      respond_to do |format|
        format.html { redirect_to domain_unit_lesson_plan_path(@domain, @domain_unit, @lesson_plan, :school_year_id => @school_year.id) }
        format.json { render :json => LessonPlanDecorator.decorate(@lesson_plan) }
      end
    else
      flash[:error] = "There was a problem cloning this lesson plan."
      render :new
    end
  end

  def public_notes
    @lesson_plan = domain_unit.lesson_plans.find(params[:id])
    @lesson_plan.public_notes = params[:lesson_plan][:public_notes]
    if @lesson_plan.save
      flash[:notice] = "Your notes have been saved."
    else
      flash[:error] = "There was a problem saving your notes."
    end
    redirect_to domain_unit_lesson_plan_path(@domain, @domain_unit, @lesson_plan, :school_year_id => @lesson_plan.domain_map.school_year_id)
  end

  def create
    @lesson_plan = domain_unit.lesson_plans.for_teacher(current_user).new(params[:lesson_plan])
    if @lesson_plan.save
      if params[:commit] == "Save and Attach Files"
        redirect_to domain_unit_lesson_plan_path(@domain, @domain_unit, @lesson_plan, :anchor => 'attached-files')
      else
        redirect_to domain_unit_lesson_plan_path(@domain, @domain_unit, @lesson_plan)
      end
    else
      flash[:error] = "There was a problem saving this lesson plan."
      render :new
    end
  end

  def update
    @lesson_plan = domain_unit.lesson_plans.for_teacher(current_user).find(params[:id])
    if @lesson_plan.update_attributes(params[:lesson_plan])
      if params[:commit] == "Save and Attach Files"
        redirect_to domain_unit_lesson_plan_path(@domain, @domain_unit, @lesson_plan, :anchor => 'attached-files', :school_year_id => @lesson_plan.domain_map.school_year_id)
      else
        redirect_to domain_unit_lesson_plan_path(@domain, @domain_unit, @lesson_plan, :school_year_id => @lesson_plan.domain_map.school_year_id)
      end
    else
      flash[:error] = "There was a problem saving this lesson plan."
      render :edit
    end
  end

  def destroy
    @lesson_plan = domain_unit.lesson_plans.for_teacher(current_user).find(params[:id])
    if @lesson_plan.destroy
      redirect_to show_domain_map_path(:domain_id => @domain.id, :school_year_id => school_year.id)
    else
      flash[:error] = "There was a problem deleting this lesson plan."
      render :edit
    end
  end

  def check_sub_guideline
    @lesson_plan = current_user.lesson_plans.find(params[:lesson_plan_id])
    @subguideline = SubGuideline.find(params[:id])
    @lesson_plan.check_sub_guideline!(@subguideline)
    respond_to do |format|
      format.json { render :json => @lesson_plan.checked_sub_guidelines }
    end
  end

  def uncheck_sub_guideline
    @lesson_plan = current_user.lesson_plans.find(params[:lesson_plan_id])
    @subguideline = SubGuideline.find(params[:id])
    @lesson_plan.uncheck_sub_guideline!(@subguideline)
    respond_to do |format|
      format.json { render :json => @lesson_plan.checked_sub_guidelines }
    end
  end

  private

  def school_year
    @school_year ||= if params[:school_year_id]
      current_user.school.school_years.find(params[:school_year_id])
    else
      current_user.school.school_year
    end
  end

  def domain_unit
    domain_map
    @domain_unit ||= current_user.school.domain_units.find(params[:domain_unit_id])
  end

  def domain_map
    @domain = Domain.find(params[:domain_id])
    @domain_map ||= current_user.school.domain_maps.where(:domain_id => @domain.id, :school_year_id => school_year.id).first_or_create!
  end

end
