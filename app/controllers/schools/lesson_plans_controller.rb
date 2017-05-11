class Schools::LessonPlansController < ApplicationController

  def show
    @lesson_plan = domain_unit.lesson_plans.find(params[:id])
  end

  private

  def domain_unit
    @domain_unit ||= current_user.domain_units.where(:domain_map_id => domain_map.id).find(params[:domain_unit_id])
  end

  def domain_map
    @domain = Domain.find(params[:domain_id])
    @domain_map ||= current_user.school.domain_maps.where(:domain_id => @domain.id).first_or_create!
  end

end
