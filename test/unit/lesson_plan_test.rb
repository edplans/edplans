require 'test_helper'

class LessonPlanTest < MiniTest::Spec

  context "a lesson plan" do

    before do
      @lesson_plan = FactoryGirl.create :lesson_plan
    end

    it "should belong to a teacher" do
      refute @lesson_plan.teacher.nil?
      assert @lesson_plan.teacher.lesson_plans.present?
    end

    it "should belong to the teacher's school" do
      assert_equal @lesson_plan.teacher.school, @lesson_plan.school
    end

    it "should belong to a domain unit" do
      refute @lesson_plan.domain_unit.nil?
    end

  end


end
