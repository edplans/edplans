class MySchool::StandardsController < ApplicationController

  before_filter :require_planner, :find_school

  def destroy
    @standard = @school.custom_standards.find(params[:id])
    if @standard.destroy
      respond_to do |format|
        format.html { redirect_to request.referer }
        format.json { render :json => { :success => :ok } }
      end
    end
  end

  def create
    @standard = @school.custom_standards.new(params[:standard])
    if @standard.save
      respond_to do |format|
        format.html { redirect_to request.referer }
        format.json { render :json => @standard }
      end
    else
      respond_to do |format|
        message =
          "Problem creating Standard: #{ @standard.errors.full_messages.join(', ') }"
        format.html { redirect_to request.referer,
                                  :flash => { :error => message }
        }
      end
    end
  end

  def update
    @standard = @school.custom_standards.find(params[:id])
    @standard.update_attributes(params[:standard])
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.json { render :json => @standard }
    end
  end

end
