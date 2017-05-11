class Admin::SubGuidelinesController < InheritedResources::Base

  before_filter :require_admin

  def create
    @sub_guideline = build_resource.tap do |s|
      s.guideline_id = params[:guideline_id]
    end
    create! { guideline_path(@sub_guideline.guideline) }
  end

  def update
    update! { guideline_path(@sub_guideline.guideline) }
  end

  def destroy
    destroy! { guideline_path(@sub_guideline.guideline) }
  end

end
