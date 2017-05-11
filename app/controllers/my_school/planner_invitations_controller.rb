class MySchool::PlannerInvitationsController < ApplicationController

  before_filter :find_school
  before_filter :require_planner, :only => [ :new, :create ]
  before_filter :lookup_invitation, :only => [ :show, :accept ]

  def new
    @planner = User.new
  end

  def create
    email = params[:user].delete(:email)
    @planner = User.new(params[:user]).tap do |user|
      user.planner = true
      user.email = email
      user.invitation_token = User.generate_invitation_token
      user.school = @school
    end
    if @planner.save && @planner.send_invitation_email
      flash[:success] = "An invitation has been sent to #{ @planner.email }."
    else
      flash[:error] = "Could not invite #{ @planner.email }."
    end
    redirect_to new_my_school_planner_invitation_path
  end

end
