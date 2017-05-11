class UsersController < InheritedResources::Base

  before_filter :require_admin, :only => [ :index, :destroy, :activate, :deactivate, :csv ]

  actions :index, :destroy, :edit, :update

  def index
    @users = User.includes(:school).order('schools.name asc').paginate(:page => params[:page], :per_page => 20)
    index!
  end

  def csv
    @users = User.includes(:school).order('schools.name asc').all.select(&:school)
    result = CSV.generate do |csv|
      csv << ["First Name", "Last Name", "Email", "School"]
      @users.each do |user|
        csv << [user.first_name, user.last_name, user.email,
                (user.school.name.blank? ? "School #{ user.school.id }" : user.school.name)]
      end
    end
    render :text => result
  end

  def edit
    @user = current_user
    edit!
  end

  def update
    @user = current_user
    if new_password = params[:user].delete(:password)
      @user.update_attribute(:password, new_password)
    end
    update! { root_path }
  end

  def activate
    user.active = true
    user.save
    respond_to do |format|
      format.json { render :json => user }
    end
  end

  def deactivate
    user.active = false
    user.save
    respond_to do |format|
      format.json { render :json => user }
    end
  end

  def resend_invitation
    user.send_invitation_email
    respond_to do |format|
      format.json { render :json => user }
    end
  end

  def destroy
    if user.invitation_token.present? && user.destroy
      respond_to do |format|
        format.json { render :json => user }
      end
    else
      error :not_found
    end
  end

  private

  def user
    @user ||= User.find(params[:id])
  end

end
