require 'test_helper'

class SchoolHolidayTest < MiniTest::Spec

  it "should belong to a school" do
    @school = FactoryGirl.create :school
    @school_holiday = FactoryGirl.create :school_holiday, :school => @school
    assert_equal @school, @school_holiday.school
    assert_equal [@school_holiday], @school.school_holidays
  end

  it "should belong to the proper school year for the school" do
    @school = FactoryGirl.create :school
    @school_year = FactoryGirl.create :school_year, :school => @school, :start_date => Date.today, :end_date => Date.today + 7.days
    @school_holiday = FactoryGirl.create :school_holiday, :start_date => Date.today + 1.day, :school => @school
    assert_equal @school_year, @school_holiday.school_year
  end

  it "should default to a one-day holiday if no end date is scheduled" do
    @school_holiday = FactoryGirl.create :school_holiday, :start_date => Date.today + 5.weeks
    assert_equal Date.today + 5.weeks, @school_holiday.end_date
  end

  it "should belong to a week in a school's year" do
    @school = FactoryGirl.create :school
    @school_year = FactoryGirl.create :school_year, :school => @school, :start_date => Date.today.beginning_of_week, :end_date => Date.today + 8.months
    @school_holiday = FactoryGirl.create :school_holiday, :school => @school, :start_date => Date.today
    assert_equal [@school_holiday], @school_year.weeks.first.holidays
  end

  it "should prevent the creation of a week when encompassing a whole week" do
    @school = FactoryGirl.create :school
    @school_year = FactoryGirl.create :school_year, :school => @school, :start_date => Date.today.beginning_of_week, :end_date => Date.today + 8.months
    @school_holiday = FactoryGirl.create :school_holiday, :school => @school, :start_date => Date.today.end_of_week + 1.day, :end_date => Date.today.end_of_week + 1.week
    assert_equal Date.today.beginning_of_week + 2.weeks, @school_year.weeks[1].start_date
  end

end
