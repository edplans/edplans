module PathHelper
  
  def path_to(name)
    
    case name
    when "curriculum management"
      upload_curriculum_path
    when "planner invitation"
      new_invitation_path(:role => 'planner')
    when "teacher invitation"
      new_teacher_invitation_path
    when "user management"
      users_path
    when "manage school"
      edit_my_school_path
    when "domains"
      domains_path
    when "domain management"
      upload_domains_path
    when "curriculum planning"
      plan_curriculum_path(:grade => "K")
    when "standards management"
      standards_path
    when "standards upload"
      new_standards_upload_path
    when "home"
      root_path
    else
      raise "Can't find #{ name.inspect } in paths.rb."
    end

  end

end

World(PathHelper)
