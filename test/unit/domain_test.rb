require 'test_helper'

class DomainTest < MiniTest::Spec
  
  it "should be applicable to both curriculum nodes and guidelines" do
    @domain = FactoryGirl.create :domain
    @node = FactoryGirl.create :curriculum_node
    @guideline = FactoryGirl.create :guideline
    @domain.curriculum_nodes << @node
    @domain.guidelines << @guideline
    assert @domain.curriculum_nodes.include?(@node)
    assert @domain.guidelines.include?(@guideline)
  end

  it "should be scopable by grade" do
    @domain = FactoryGirl.create :domain, :grade => "K"
    assert Domain.for_grade("K").include?(@domain)
    refute Domain.for_grade("1").include?(@domain)
  end

  it "should belong to the common list when no school is specified" do
    @domain = FactoryGirl.create :domain
    assert Domain.common.all.include?(@domain)
  end

  it "should calculate a number of weeks from its days" do
    @domain = FactoryGirl.create :domain, :days => 17
    assert_equal 4, @domain.weeks
    @domain = FactoryGirl.create :domain, :days => 3
    assert_equal 1, @domain.weeks
  end

  context "a custom domain" do
    before do
      @school = FactoryGirl.create :school
      @domain = FactoryGirl.create :domain, :school => @school
    end

    it "should belong to a school when specified" do
      assert @school.custom_domains.include?(@domain)
      refute Domain.common.all.include?(@domain)
    end

    it "should delete all scheduled domains when deleted" do
      FactoryGirl.create :scheduled_domain, :school => @school, :domain => @domain
      @domain.destroy
      assert_equal 0, @school.scheduled_domains.count
    end
  end
  
end
