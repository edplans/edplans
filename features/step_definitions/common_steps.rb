When /^I visit the ([^\"]*) page$/ do |page_name|
  visit path_to(page_name)
end

When /^I follow the link to "([^\"]*)"$/ do |link|
  click_link link
end

Then /^"([^\"]*)" should receive an email$/ do |address|
  @most_recent_email = ActionMailer::Base.deliveries[0]
end

Then "show me the page" do
  save_and_open_page
end
