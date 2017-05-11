Given "I have set up my school" do
  @me.school = FactoryGirl.create :school
end

When "I set my school's year" do
  fill_in "school_year_start", :with => Date.today.strftime("%m/%d/%Y")
  fill_in "school_year_end", :with => (Date.today + 8.months).strftime("%m/%d/%Y")
  click_button "Update"
end

When "I add a holiday" do
  sleep 1
  fill_in "school_holiday_start_date", :with => (@me.school.year_start + 1.week).strftime("%m/%d/%Y")
  fill_in "Name", :with => "#{ Faker::Name.name } Day"
  click_button "Add"
  sleep 1
end

Then "my school's year should have start and end dates" do
  assert_not_nil @me.school.year_start
  assert_not_nil @me.school.year_end  
end

Then "my school's year should have a holiday" do
  refute @me.school.school_holidays.empty?
end
