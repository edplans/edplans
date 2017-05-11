class ScheduledDomainsController < InheritedResources::Base

  respond_to :json

  before_filter :require_planner

  def update
    update! do |success, failure|
      success.json { render :json => @scheduled_domain }
    end
  end

#  def create
#    params[:scheduled_domain] = params["0"].reject {|k,v| k == "domain_name"}
#    create!
#  end

  protected

  def begin_of_association_chain
    current_user.school
  end

end
