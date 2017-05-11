require 'test_helper'

class LoginEventTest < MiniTest::Spec

  it "should mark the user's current role when created" do
    planner = FactoryGirl.create :planner
    event = LoginEvent.create :user => planner
    assert_equal :planner, event.reload.role
  end

end
