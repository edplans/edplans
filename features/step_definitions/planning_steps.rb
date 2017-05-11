When "I add a custom domain" do
  domain_attrs = FactoryGirl.attributes_for :domain
  click_link "Create New..."
  sleep 0.5
  click_link "New Domain"
  fill_in "Name", :with => domain_attrs[:name]
  fill_in "Days", :with => domain_attrs[:days]
  click_button "Create"
end

When "I drag a domain on to the calendar" do
  @domain = Domain.first
  find(:xpath, "//span[@data-domain-id='#{ @domain.id }']").drag_to(find("td.week-cell"))
end

When "I drag my custom domain to the calendar" do
  find(:xpath, "//span[@data-domain-id='#{ @domain.id }']").drag_to(find("td.week-cell"))
end

When "I omit a domain" do
  @domain = Domain.first
  find("a#omit-domain-#{ @domain.id }").click
end

Then "I should see a week-by-week calendar for my school" do
  @me.school.school_year.weeks.each do |week|
    assert page.has_selector?("td#week-#{ week.index }")
  end
  @me.school.school_year.months.each do |month|
    assert page.has_content?(month.name)
  end
end

Then "I should see a list of available domains for Kindergarten" do
  Domain.for_grade("K").all.each do |domain|
    assert page.has_content?(domain.name)
  end
end

Then "that domain should be scheduled" do
  sleep 1
  assert ScheduledDomain.where(:domain_id => @domain.id, :school_id => @me.school.id).count == 1
end

Then "that domain should be hidden" do
  sleep 1
  refute @me.school.reload.includes_domain?(@domain)
end

Then "the custom domain should exist" do
  sleep 1
  @domain = @me.school.custom_domains.last
  assert_not_nil @domain
end
