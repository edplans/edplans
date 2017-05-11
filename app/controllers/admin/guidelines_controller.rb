class Admin::GuidelinesController < InheritedResources::Base

  before_filter :require_admin

  def show
    @subjects = CurriculumNode.roots.all
    show!
  end

  def new
    @guideline = curriculum_node.guidelines.new
  end

  def create
    @guideline = curriculum_node.guidelines.new(params[:guideline])
    if @guideline.save
      redirect_to guideline_path(@guideline)
    else
      flash.now[:error] = "There was a problem creating this guideline."
      render :new
    end
  end

  def update
    update! { guideline_path(@guideline) }
  end

  def destroy
    destroy! { curriculum_node_path(@guideline.curriculum_node) }
  end

  private

  def resource
    @guideline ||= Guideline.includes(:knowledge_connections, :domain_applications, :standard_applications, :sub_guidelines).find(params[:id])
  end

  def curriculum_node
    @curriculum_node ||= CurriculumNode.find(params[:curriculum_node_id])
  end

end
