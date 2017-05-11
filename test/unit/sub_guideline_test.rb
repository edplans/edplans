require 'test_helper'

class SubGuidelineTest < MiniTest::Spec

  it "should belong to a guideline" do
    @guideline = FactoryGirl.create(:guideline)
    @subguideline = FactoryGirl.create(:sub_guideline, :guideline => @guideline)
    assert_equal @guideline, @subguideline.guideline
  end

end
