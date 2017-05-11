class WelcomeController < ApplicationController

  def index
    redirect_to user_landing_path if current_user.present?
  end

end
