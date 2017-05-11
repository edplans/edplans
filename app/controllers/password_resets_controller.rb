class PasswordResetsController < ApplicationController

  skip_before_filter :require_login

  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.deliver_reset_password_instructions!
      redirect_to root_path, :notice => "Password reset instructions have been sent to #{ @user.email }"
    else
      flash.now[:error] = "Sorry, no user with that email was found."
      render :new
    end
  end

  def edit
    @user = User.load_from_reset_password_token(params[:id])
    @token = params[:id]
    not_authenticated unless @user
  end

  def update
    @token = params[:token]
    @user = User.load_from_reset_password_token(params[:token])
    unless @user
      not_authenticated and return
    end

    if @user.change_password!(params[:user][:password])
      auto_login(@user)
      redirect_to(root_path, :notice => 'Password was successfully updated.')
    else
      render :edit
    end
  end


end
