class MySchool::TeacherInvitationsController < ApplicationController

  before_filter :find_school
  before_filter :require_planner, :only => [ :new, :create ]
  before_filter :lookup_invitation, :only => [ :show, :accept ]

  def new
    @teacher = User.new
  end

  def create
    email = params[:user].delete(:email)
    @teacher = User.new(params[:user]).tap do |user|
      user.teacher = true
      user.email = email
      user.invitation_token = User.generate_invitation_token
      user.school = @school
    end
    if @teacher.save && @teacher.send_invitation_email
      flash[:success] = "An invitation has been sent to #{ @teacher.email }."
    else
      flash[:error] = "Could not invite #{ @teacher.email }."
    end
    redirect_to new_teacher_invitation_path
  end

end
