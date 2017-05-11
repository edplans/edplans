class MySchool::UsersController < ApplicationController

  before_filter :require_planner
  before_filter :find_school

  def index
    @users = @school.teachers
  end

  def activate
    user.active = true
    user.save
    respond_to do |format|
      format.json { render :json => user }
    end
  end

  def deactivate
    user.active = false
    user.save
    respond_to do |format|
      format.json { render :json => user }
    end
  end

  def promote
    user.planner = true
    user.save
    respond_to do |format|
      format.json { render :json => user }
    end
  end

  def demote
    user.planner = false
    user.teacher = true
    user.save
    respond_to do |format|
      format.json { render :json => user }
    end
  end

  private

  def user
    @user ||= @school.teachers.find(params[:id])
  end

end
