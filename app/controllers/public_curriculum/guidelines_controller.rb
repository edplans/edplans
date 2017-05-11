class PublicCurriculum::GuidelinesController < ApplicationController

  def show
    @guideline = Guideline.includes(:sub_guidelines).find(params[:id])
  end

end
