require 'test_helper'

class StandardApplicationTest < MiniTest::Spec

  it "should associate a standard and a guideline" do
    @standard_application = FactoryGirl.create :standard_application
    refute (@standard = @standard_application.standard).nil?
    refute (@guideline = @standard_application.guideline).nil?
    assert @guideline.standards.include?(@standard)
    assert @standard.guidelines.include?(@guideline)
  end

end
