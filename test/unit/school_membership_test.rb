require 'test_helper'

class SchoolMembershipsTest < MiniTest::Spec

  context "an existing school" do
    before do
      @school = FactoryGirl.create :school
    end

    it "should associate a teacher and a school" do
      @teacher = FactoryGirl.create :teacher
      @teacher.school = @school
      assert_equal [@teacher], @school.teachers
    end

    it "should not allow a teacher to be associated to two schools" do
      @teacher = FactoryGirl.create :teacher
      @teacher.school = @school
      @another_school = FactoryGirl.create :school
      refute SchoolMembership.new(:user => @teacher, :school => @another_school).valid?
    end
  end


end
