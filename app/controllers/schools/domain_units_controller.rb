class Schools::DomainUnitsController < ApplicationController

  before_filter :require_teacher
  before_filter :find_school
  before_filter :find_domain_map

  def create
    @domain_unit = current_user.domain_units.new(params[:domain_unit]).tap do |u|
      u.domain_map_id = @domain_map.id
      u.school = current_user.school
    end
    if @domain_unit.save
      respond_to do |format|
        format.json { render :json => DomainUnitDecorator.decorate(@domain_unit) }
      end
    else
      respond_to do |format|
        format.json { render :json => @domain_unit.errors, :status => :bad_request }
      end
    end
  end

  def update
    @domain_unit = current_user.domain_units.find(params[:id])
    if @domain_unit.update_attributes(params[:domain_unit])
      respond_to do |format|
        format.json { render :json => DomainUnitDecorator.decorate(@domain_unit) }
      end
    else
      respond_to do |format|
        format.json { render :json => @domain_unit.errors, :status => :bad_request }
      end
    end
  end

  def destroy
    @domain_unit = current_user.domain_units.find(params[:id])
    if @domain_unit.lesson_plans.empty? && @domain_unit.destroy
      respond_to do |format|
        format.json { render :json => @domain_unit }
      end
    else
      respond_to do |format|
        format.json { render :json => { 'error' => 'could not delete domain unit' }, :status => :bad_request }
      end
    end
  end

  private 

  def find_domain_map
    @domain = Domain.find(params[:domain_id])
    @domain_map = @school.domain_maps.where(:domain_id => @domain.id).first_or_create!
  end

end
