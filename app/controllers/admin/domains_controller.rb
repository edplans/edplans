class Admin::DomainsController < ApplicationController

  before_filter :require_admin

  def upload
    begin
      Domain.import(CSV.read(params[:file].tempfile, :headers => true))
      flash[:success] = "Domains imported successfully!"
    rescue Exception => e
      logger.error "Error importing curriculum: #{ e.inspect }"
      flash[:error] = "There was a problem importing your file. Please check the format and try again. The error: #{ e.inspect }"
    end
    redirect_to upload_domains_path
  end

  def clear
    Domain.destroy_all
    flash[:success] = "All domains have been deleted."
    redirect_to upload_domains_path
  end

  def update
    @domain = Domain.find(params[:id])
    if @domain.update_attributes(params[:domain])
      flash[:success] = "Your changes have been saved."
    else
      flash[:error] = "There was a problem saving your changes."
    end
    redirect_to domains_grade_path(@domain.grade)
  end

  def destroy
    @domain = Domain.find(params[:id])
    if @domain.destroy
      flash[:success] = "This domain has been deleted."
    else
      flash[:error] = "There was a problem deleting this domain."
    end
    redirect_to domains_path
  end


end
