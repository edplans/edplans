require 'test_helper'

class GuidelineTest < MiniTest::Spec

  it "should have a parent curriculum node" do
    @node = FactoryGirl.create :curriculum_node
    @guideline = FactoryGirl.create :guideline, :curriculum_node => @node
    assert_equal @node, @guideline.curriculum_node
  end

  it "should have domains" do
    @guideline = FactoryGirl.create :guideline
    @domain = FactoryGirl.create :domain
    @guideline.domains << @domain
    assert @guideline.domains.include?(@domain)
  end

  context "in a tree of curriculum" do
    before do
      @subject = FactoryGirl.create :curriculum_node
      @grade = FactoryGirl.create :curriculum_node, :parent => @subject
      @unit = FactoryGirl.create :curriculum_node, :parent => @grade
      @guideline = FactoryGirl.create :guideline, :curriculum_node => @unit
    end
 
    it "should inherit domains from its parent curriculum" do
      @domain = FactoryGirl.create :domain
      @grade.domains << @domain
      assert @guideline.inherited_domains.include?(@domain)
    end
  end

end
