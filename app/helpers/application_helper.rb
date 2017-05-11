module ApplicationHelper

  def current_user_is_admin?
    current_user && current_user.admin?
  end

  def current_user_is_planner?
    current_user && current_user.planner?
  end

  def current_user_is_teacher?
    current_user && current_user.teacher?
  end

  def short_error_messages_for(object)
    object.errors.messages.map do |name, msgs|
      "#{ name.to_s.gsub('_', ' ') } #{ msgs.join(', ')}"
    end.join('; ').capitalize + "."
  end

  def name_for_school(user)
    user.try(:school).try(:name).present? ? user.school.name : "My School"
  end

  def persisted_month_fragment(school_year_id)
    (session[:persisted_months] &&
     session[:persisted_months][school_year_id]) || nil
  end
end
