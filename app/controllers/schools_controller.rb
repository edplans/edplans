class SchoolsController < ApplicationController

  before_filter :require_admin

  def index
    @schools = School.where('created_at > ?', Date.today - 2.years).order('created_at desc')
  end

end
