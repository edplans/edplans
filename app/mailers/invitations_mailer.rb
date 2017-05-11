class InvitationsMailer < ActionMailer::Base
  default :from => "noreply@coreknowledge.org"

  def invitation(user)
    @user = user
    mail :to => user.email, :subject => "You have been invited to #{ t('app_name') }!"
  end

  def invitation_for_new_school(user)
    @user = user
    mail :to => user.email, :subject => "You have been invited to #{ t('app_name') }!"
  end
end
