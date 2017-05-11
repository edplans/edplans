class Admin::StandardsController < ApplicationController

  before_filter :require_admin

  def new_upload
  end

  def upload
    begin
      Standard.import(CSV.read(params[:file].tempfile, :headers => true))
      flash[:success] = "Standards imported successfully!"
    rescue Exception => e
      logger.error "Error importing standards: #{ e.inspect }"
      flash[:error] = "There was a problem importing your file. Please check the format and try again. The error: #{ e.inspect }"
    end
    redirect_to standards_path
  end

  def clear
    Standard.delete_all
    StandardApplication.delete_all
    flash[:notice] = "All standards have been destroyed!"
    redirect_to standards_path
  end

  def index
    @standards = standards.all.select(&:ck_code)
  end

  def show
    standard
  end

  def new
    @standard = standards.new(:position => max_common_position + 1)
  end
  
  def create
    @standard = standards.new(params[:standard])
    if @standard.save
      flash[:success] = "#{ standard.ck_code } has been created."
      redirect_to standards_path
    else
      flash.now[:error] = "There was a problem saving this standard."
      render :new
    end
  end

  def edit
    standard
  end

  def update
    if standard.update_attributes(params[:standard])
      flash[:success] = "Your changes to #{ standard.ck_code } have been saved."
      redirect_to standards_path
    else
      flash.now[:error] = "There was a problem saving your changes."
      render :edit
    end
  end

  def destroy
    standard.destroy
    flash[:success] = "#{ standard.ck_code } has been deleted."
    redirect_to standards_path
  end

  private

  def standard
    @standard ||= if params[:id]
                    standards.find(params[:id])
                  elsif params[:ck_code]
                    standards.where(:ck_code => params[:ck_code]).first
                  end
  end

  def standards
    @standards ||= Standard.common
  end

  def max_common_position
    @max_common_position ||= Standard.unscoped.common.select('max(position)').first['max'].to_i
  end

end
