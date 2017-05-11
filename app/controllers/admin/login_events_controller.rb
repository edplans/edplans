class Admin::LoginEventsController < ApplicationController

  before_filter :require_admin

  def index
    @login_events = LoginEvent.where('created_at > ?', Date.today - 2.weeks).order('created_at desc').includes(:user)
  end

end
