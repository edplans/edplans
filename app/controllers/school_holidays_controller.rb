class SchoolHolidaysController < InheritedResources::Base
  include ApplicationHelper

  respond_to :json

  before_filter :require_planner

  def create
    create! do |success, failure|
      success.html { redirect_to edit_school_year_path(resource.school_year) }
      failure.html { flash[:error] = short_error_messages_for(@school_holiday); redirect_to edit_my_school_path }
    end
  end

  protected
  
  def begin_of_association_chain
    current_user.school
  end
end
