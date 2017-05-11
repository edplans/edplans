class Teachers::LessonPlanFilesController < ApplicationController

  def create
    @lesson_plan = current_user.lesson_plans.find(params[:lesson_plan_id])
    @lesson_plan_file = @lesson_plan.lesson_plan_files.new(params[:lesson_plan_file])
    if @lesson_plan_file.save
      flash[:notice] = "Your file has been successfully uploaded."
    else
      flash[:error] = "There was a problem saving your file."
    end
    redirect_to domain_unit_lesson_plan_path(@lesson_plan.domain_id, @lesson_plan.domain_unit, @lesson_plan)
  end

  def destroy
    @lesson_plan = current_user.lesson_plans.find(params[:lesson_plan_id])
    @lesson_plan_file = @lesson_plan.lesson_plan_files.find(params[:id])
    if @lesson_plan_file.destroy
      flash[:notice] = "This file has been deleted."
    else
      flash[:error] = "There was a problem deleting this file."
    end
    redirect_to domain_unit_lesson_plan_path(@lesson_plan.domain_id, @lesson_plan.domain_unit, @lesson_plan)
  end

end
