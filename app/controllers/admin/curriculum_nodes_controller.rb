class Admin::CurriculumNodesController < ApplicationController
  
  before_filter :require_admin

  def new
    if params[:id]
      @curriculum_node = parent_node.children.new
      puts @curriculum_node.inspect
    else
      @curriculum_node = CurriculumNode.new
    end
  end

  def create
    @curriculum_node = CurriculumNode.new(params[:curriculum_node])
    if @curriculum_node.save
      redirect_to curriculum_node_path(@curriculum_node)
    else
      flash.now[:error] = "There was a problem creating this #{ @curriculum_node.level_name }"
      render 'new'
    end
  end

  private

  def parent_node
    @parent_node ||= CurriculumNode.find(params[:id])
  end

end
