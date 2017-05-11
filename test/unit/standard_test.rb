require 'test_helper'

class StandardTest < MiniTest::Spec

  it "should be creatable" do
    @standard = FactoryGirl.create :standard
    assert @standard.valid?
  end

end
