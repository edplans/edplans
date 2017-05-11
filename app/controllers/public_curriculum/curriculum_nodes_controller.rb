class PublicCurriculum::CurriculumNodesController < ApplicationController

  def show
    @node = CurriculumNode.find(params[:id], :include => [ :domains, { :guidelines => [ :standards, :domains ] } ])
  end

  def index
    @nodes = CurriculumNode.roots.order('position asc')
  end

end
