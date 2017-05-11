class InvitationsController < ApplicationController

  include UserSessionsHelper # New planner signup text

  before_filter :require_admin, :only => [ :new, :create ]
  before_filter :lookup_invitation, :only => [ :show, :accept ]

  def new
    @role = params[:role]
    @user = User.new
  end

  def new_school
    @user = User.new
  end

  def create
    @user = User.new.tap do |user|
      user.email = params[:user][:email]
      unless params[:role].to_sym == :admin
        user.school = current_user.school || School.create
      end
      user.invitation_token = User.generate_invitation_token
      user.send "#{params[:role]}=", true
    end
    if @user.save && @user.send_invitation_email
      flash[:success] = "An invitation has been sent to #{ @user.email }."
    else
      flash[:error] = "Could not invite #{ @user.email }."
    end
    redirect_to new_invitation_path(:role => params[:role])
  end

  def create_school
    @school = School.create
    @user = User.new.tap do |user|
      user.email = params[:user][:email]
      user.school = @school
      user.invitation_token = User.generate_invitation_token
      user.planner = true
    end
    if @user.save && @user.send_new_school_invitation_email
      flash[:success] = "The school has been created and an invitation has been sent to #{ @user.email }."
    else
      flash[:error] = "There was a problem creating this user; could not invite #{ @user.email }."
    end
    redirect_to new_school_invitation_path
  end

  def show
  end

  def accept
    @user.password = params[:user].delete(:password)
    params[:user].delete(:email)
    if @user.update_attributes(params[:user])
      auto_login(@user)
      if @user.planner? && @user.school.name.blank?
        redirect_to edit_my_school_path, :notice => first_planner_signin_text.html_safe
      else
        flash[:success] = "Thank you for signing up!"
        redirect_to root_path, :success => "Thank you for signing up!"
      end
    else
      if params[:user][:terms] == "0"
        flash[:error] = "You must accept the terms of use to use this software."
      else
        flash[:error] = "There was a problem setting your password."
      end
      redirect_to accept_invitation_path(:token => @user.invitation_token)
    end
  end

  private

  def lookup_invitation
    unless @user = User.where(:invitation_token => params[:token]).first
      flash[:error] = "Could not verify your invitation"
      redirect_to sign_in_path
    end
  end

end
