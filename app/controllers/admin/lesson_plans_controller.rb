class Admin::LessonPlansController < ApplicationController

  before_filter :require_admin, :set_since

  def index
    @lesson_plans = LessonPlan.where('created_at > ?', opening_date).
                    order('created_at desc').includes(:teacher).
                    includes(:domain_unit => { :domain_map => :domain
                                             }).
                    paginate(:page => params[:page], :per_page => 30)
    load_lesson_plan_activity
  end

  private

  def opening_date # June 30, 2014
    @@opening_date ||= Date.new 2014, 6, 30
  end
  helper_method :opening_date

  def set_since
    @since = params[:since].present? ? Date.parse(params[:since])
             : opening_date
  end

  def load_lesson_plan_activity
    @created_count = LessonPlan.where('created_at >= ?', @since).count
    @updated_count =
      LessonPlan.where('updated_at >= ? and updated_at > created_at',
                       @since).count
  end

end
