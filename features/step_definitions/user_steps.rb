require 'launchy'

Given "I am a registered administrator" do
  @password = "password123"
  @me = FactoryGirl.create :admin, :password => @password
end

Given "I am a registered planner" do
  @password = "password123"
  @me = FactoryGirl.create :planner, :password => @password
end

Given "I am a registered teacher" do
  @password = "password123"
  @me = FactoryGirl.create :teacher, :password => @password
end

Given "I am a registered user" do
  @password = "password123"
  @me = FactoryGirl.create :user, :password => @password
end

Given "I am not a registered user" do
  @email = Faker::Internet.email
  assert_nil User.where(:email => @email).first
end

Given "registered users exist" do
  4.times { FactoryGirl.create :user }
end

When "I sign in" do
  visit '/sign_in'
  fill_in 'Email', :with => @me.email
  fill_in 'Password', :with => @password
  click_button 'Sign In'
end

When /^I enter a password$/ do
  @password = "password456"
  fill_in 'Password', :with => @password
  click_button 'Accept Invitation'
end

Then "I should be signed in" do
  assert page.has_content?('Sign Out')
  refute page.has_content?('Sign In')
end

Then "I should not be authorized" do
  assert page.has_content?("You are not authorized to view this page.")
end

Then /^I should be signed up as a (teacher|planner)$/ do |role|
  assert @me.reload.invitation_token.nil?
  assert @me.send("#{ role }?".to_sym)
end

When "I delete a user" do
  @user = User.where(['id != ?', @me.id]).first
  within "tr#user-#{ @user.id }" do
    click_button "Delete"
  end
end

Then "that user should not exist" do
  assert_raises ActiveRecord::RecordNotFound do
    User.find(@user.id)
  end
end
