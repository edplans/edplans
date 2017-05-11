class CurriculumController < ApplicationController

  before_filter :require_admin

  def new
    @grades = CurriculumNode.where(:ancestry_depth => 1).map(&:name).uniq.inject([["All", nil]]) { |acc, grade| acc << [grade, grade] }
  end
  
  def upload
    begin 
      CurriculumNode.import(CSV.read(params[:file].tempfile.path, 'rb', :headers => true))
      flash[:success] = "Curriculum imported successfully!"
    rescue Exception => e
      logger.error "Error importing curriculum: #{ e.inspect }"
      flash[:error] = "There was a problem importing your file. Please check the format and try again. The error: #{ e.inspect }"
    end
    redirect_to curriculum_path
  end

  def node
    @node = CurriculumNode.find(params[:id], :include => [ :domains, { :guidelines => [ :standards, :domains ] } ])
  end

  def clear
    if params[:grade].present?
      CurriculumNode.where(:name => params[:grade]).destroy_all
      flash[:success] = "Curriculum for #{ params[:grade] } has been deleted."
    else
      CurriculumNode.destroy_all
      DomainMap.delete_all
      LessonPlan.delete_all
      flash[:success] = "All curriculum has been deleted."
    end
    redirect_to upload_curriculum_path
  end

  def edit
    @node = CurriculumNode.find(params[:id])
  end

  def update
    @node = CurriculumNode.find(params[:id])
    if @node.update_attributes(params[:curriculum_node])
      flash[:success] = "Your changes have been saved."
    else
      flash[:error] = "There was a problem saving your changes."
    end
    redirect_to curriculum_node_path(@node)
  end

  def destroy
    @node = CurriculumNode.find(params[:id])
    if @node.destroy
      flash[:success] = "This curriculum node has been deleted."
    else
      flash[:error] = "There was a problem deleting this curriculum node."
    end
    redirect_to curriculum_path
  end

end
