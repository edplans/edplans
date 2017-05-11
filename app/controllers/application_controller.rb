class ApplicationController < ActionController::Base
  protect_from_forgery

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: lambda { |exception|
      notify_airbrake exception
      render_error 500, exception
    }
    rescue_from ActionController::RoutingError, ActionController::UnknownController, ::AbstractController::ActionNotFound, ActiveRecord::RecordNotFound, with: lambda { |exception| render_error 404, exception }
  end

  private

  # via https://gist.github.com/1563416
  def render_error(status, exception)
    respond_to do |format|
      format.html { render template: "errors/error_#{status}", layout: 'layouts/application', status: status }
      format.all { render nothing: true, status: status }
    end
  end

  def require_admin
    unless current_user.present? && current_user.admin?
      flash[:error] = "You are not authorized to view this page."
      redirect_to(:sign_in) and return
    end
  end

  def require_planner
    unless current_user.present? && current_user.planner?
      flash[:error] = "You are not authorized to view this page"
      redirect_to root_path and return
    end
  end

  def require_admin_or_planner
    unless current_user.present? && (current_user.admin? || current_user.planner?)
      flash[:error] = "You are not authorized to view this page"
      redirect_to root_path and return
    end
  end

  def require_teacher
    unless current_user.present? && current_user.teacher?
      flash[:error] = "You are not authorized to view this page"
      redirect_to root_path and return
    end
  end

  def find_school
    @school ||= (current_user.school || School.create.tap {|s| s.planner = current_user })
  end


end
