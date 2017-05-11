Given "I have received a planner invitation" do
  @me = FactoryGirl.create :planner, :password => nil, :invitation_token => User.generate_invitation_token, :email => @email
  @me.send_new_school_invitation_email
  step "#{ @email.inspect } should receive an email"
end

Given "I have received a teacher invitation" do
  @me = FactoryGirl.create :teacher, :password => nil, :invitation_token => User.generate_invitation_token, :email => @email
  @me.send_invitation_email
  step "#{ @email.inspect } should receive an email"
end

When /^I follow the link in the invitation email$/ do
  assert @me.email, @most_recent_email.to.first
  visit accept_invitation_path(:token => @me.invitation_token)
end

When /^I invite a new planner$/ do
  @email = Faker::Internet.email
  fill_in "Email Address", :with => @email
  click_button "Invite"
end

When /^I invite a new teacher$/ do
  @email = Faker::Internet.email
  first_name, last_name = Faker::Name.first_name, Faker::Name.last_name
  fill_in "Email Address", :with => @email
  fill_in "First Name", :with => first_name
  fill_in "Last Name", :with => last_name
  click_button "Invite"
end

Then /^the (teacher|planner) should receive an email invitation$/ do |_|
  step "#{ @email.inspect } should receive an email"
  assert_equal "You have been invited to Domain Planner!", @most_recent_email.subject
end
