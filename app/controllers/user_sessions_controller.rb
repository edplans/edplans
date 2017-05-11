class UserSessionsController < ApplicationController

  include UserSessionsHelper

  skip_before_filter :require_login, :except => [:destroy]

  def new
    @user = User.new

    respond_to do |format|
      format.html
    end
  end

  def create
    respond_to do |format|
      if @user = login(params[:email],params[:password],params[:remember])
        LoginEvent.create :user => @user
        if @user.planner? && @user.school.name.blank?
          format.html { redirect_to edit_my_school_path, :notice => first_planner_signin_text.html_safe }
        elsif @user.name.blank?
          format.html { redirect_to me_path, :notice => "Please set your name." }
        else
          format.html { redirect_back_or_to(:user_landing, :success => 'Thank you for signing in.') }
        end
      else
        format.html { flash.now[:error] = "We couldn't log you in."; render :action => "new" }
      end
    end
  end

  def destroy
    logout
    redirect_to(:root, :notice => 'You have been signed out.')
  end


end
