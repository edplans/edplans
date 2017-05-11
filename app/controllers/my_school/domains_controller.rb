class MySchool::DomainsController < ApplicationController

  before_filter :require_planner, :find_school

  def destroy
    @domain = @school.custom_domains.find(params[:id])
    if @domain.destroy
      respond_to do |format|
        format.json { render :json => { :success => :ok } }
      end
    end
  end

  def create
    @domain = @school.custom_domains.create(params[:domain])
    respond_to do |format|
      format.html { redirect_to plan_curriculum_path }
      format.json { render :json => SchoolDomainDecorator.decorate(@domain) }
    end
  end

  def update
    @domain = Domain.find(params[:id])
    if @domain.is_custom?
      @domain.update_attributes(params[:domain])
    else
      if params[:included]
        @school.include_domain!(@domain)
      else
        @school.omit_domain!(@domain)
      end
    end
    respond_to do |format|
      format.json { render :json => SchoolDomainDecorator.decorate(@domain) }
    end
  end

end
