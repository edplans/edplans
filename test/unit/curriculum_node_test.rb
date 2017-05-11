require 'test_helper'

class CurriculumNodeTest < MiniTest::Spec

  it "should have domains" do
    @node = FactoryGirl.create :curriculum_node
    @domain = FactoryGirl.create :domain
    @node.domains << @domain
    assert @node.domains.include?(@domain)
  end
  
  context "a list of second level nodes" do
    before do
      @parent = FactoryGirl.create :curriculum_node
      @node = FactoryGirl.create :curriculum_node, :parent => @parent
      @node2 = FactoryGirl.create :curriculum_node, :parent => @parent
    end
    
    it "should have a parent" do
      assert_equal @node.parent, @parent
    end

    it "should be reorderable" do
      assert_equal 2, @node2.position
      @node2.move_to_top
      assert_equal 1, @node2.position
    end
  end

  context "a single tree of nodes" do
    before do
      @subject = FactoryGirl.create :curriculum_node
      @grade = FactoryGirl.create :curriculum_node, :parent => @subject
      @unit = FactoryGirl.create :curriculum_node, :parent => @grade
      @topic = FactoryGirl.create :curriculum_node, :parent => @unit
    end

    it "should have a curriculum level name" do
      assert_equal "Subject Area", @subject.level_name
      assert_equal "Grade Level", @grade.level_name
      assert_equal "Unit", @unit.level_name
      assert_equal "Topic", @topic.level_name
    end

    it "should inherit domains from its ancestors" do
      @domain = FactoryGirl.create :domain
      @grade.domains << @domain
      assert @topic.inherited_domains.include?(@domain)
      refute @subject.inherited_domains.include?(@domain)
    end
  end

end
