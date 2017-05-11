class PasswordMailer < ActionMailer::Base
  default from: "noreply@coreknowledge.org"

  def reset_password_email(user)
    @user = user
    @url = edit_password_reset_url(user.reset_password_token, :format => :html)
    mail :to => user.email,
         :subject => "How to reset your Domain Planner password"
  end

end
