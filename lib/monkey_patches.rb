# To catch `current_user` on non-logged-in actions
class FalseClass

  def school
    raise ActiveRecord::RecordNotFound
  end

end
