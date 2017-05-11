require 'test_helper'

class KnowledgeConnectionTest < MiniTest::Spec

  context "with a guideline" do
    before do
      @guideline = FactoryGirl.create :guideline
    end      

    it "should connect a guideline to prior knowledge" do
      @prior = FactoryGirl.create :curriculum_node
      @connection = KnowledgeConnection.create :prior_knowledge => @prior, :guideline => @guideline
      assert_equal [@prior], @guideline.prior_knowledge_connections
    end

    it "should connect a guideline to future knowledge" do
      @future = FactoryGirl.create :curriculum_node
      @connection = KnowledgeConnection.create :future_knowledge => @future, :guideline => @guideline
      assert_equal [@future], @guideline.future_knowledge_connections
    end
    
    it "should connect a guideline to cross curricular knowledge" do
      @cross = FactoryGirl.create :curriculum_node
      @connection = KnowledgeConnection.create :cross_knowledge => @cross, :guideline => @guideline
      assert_equal [@cross], @guideline.cross_knowledge_connections
    end

    it "should not be valid with no curriculum node" do
      @connection = KnowledgeConnection.new :guideline => @guideline
      refute @connection.valid?
    end

    it "should not be valid with both a future and prior curriculum node" do
      @prior = FactoryGirl.create :curriculum_node
      @future = FactoryGirl.create :curriculum_node
      @connection = KnowledgeConnection.new :guideline => @guideline, :prior_knowledge => @prior, :future_knowledge => @future
      refute @connection.valid?
    end
    
  end

end
