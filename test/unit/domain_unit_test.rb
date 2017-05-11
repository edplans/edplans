require 'test_helper'

class DomainUnitTest < MiniTest::Spec

  it "should belong to a domain map" do
    @map = FactoryGirl.create :domain_map
    @domain_unit = FactoryGirl.create :domain_unit, :domain_map => @map
    assert_equal @map, @domain_unit.domain_map
  end

  it "should belong to a teacher" do
    @teacher = FactoryGirl.create :teacher
    @domain_unit = FactoryGirl.create :domain_unit, :teacher => @teacher
    assert_equal @teacher, @domain_unit.teacher
  end

  it "should belong to a subject" do
    @subject = FactoryGirl.create :curriculum_node
    @domain_unit = FactoryGirl.create :domain_unit, :subject => @subject
    assert_equal @subject, @domain_unit.subject
  end

  it "should belong to a school" do
    @school = FactoryGirl.create :school
    @domain_unit = FactoryGirl.create :domain_unit, :school => @school
    assert_equal @school, @domain_unit.school
  end

  it "should have lesson plans" do
    @domain_unit = FactoryGirl.create :domain_unit
    @lesson_plan = FactoryGirl.create :lesson_plan, :domain_unit => @domain_unit
    assert_equal [@lesson_plan], @domain_unit.lesson_plans
  end

end
