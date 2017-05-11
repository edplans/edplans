require 'test_helper'

class SchoolYearTest < MiniTest::Spec

  context "a school year belonging to a school" do
    before do
      @school = FactoryGirl.create :school
      @school_year = FactoryGirl.create :school_year, :school => @school, :start_date => Date.today.beginning_of_week + 3.days, :end_date => Date.today.beginning_of_week + 30.weeks
    end

    it "should report its school" do
      assert_equal @school, @school_year.school
    end

    it "should have an array of months" do
      months = @school_year.end_date.month - @school_year.start_date.month + 1
      months += 12 if (months < 0)
      assert_equal months, @school_year.months.size
      assert @school_year.months.first.is_a?(SchoolYear::Month)
    end

    it "should have an array of weeks" do
      weeks = ((@school_year.end_date - @school_year.start_date) / 7.0).ceil
      assert_equal weeks, @school_year.weeks.size
      assert @school_year.weeks.first.is_a?(SchoolYear::Week)
      assert_equal 1, @school_year.weeks.first.index
    end

    it "should have a single-day schedule by default" do
      assert_equal ["A"], @school_year.schedule
    end
    
  end

end
