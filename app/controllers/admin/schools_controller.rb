class Admin::SchoolsController < ApplicationController

  before_filter :require_admin

  def index
    @schools = School.order('created_at desc').paginate(:page => params[:page], :per_page => (params[:per_page] || 10))
  end

end
