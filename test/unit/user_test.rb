require 'test_helper'

class UserTest < MiniTest::Spec

  it "should report whether it is an admin" do
    assert FactoryGirl.create(:admin).admin?
    refute FactoryGirl.create(:user).admin?
  end

  context "being invited" do
    before do
      @token = User.generate_invitation_token
      @user = FactoryGirl.create :user, :password => nil, :invitation_token => @token
    end
    
    it "should be findable based on token" do
      assert_equal @user, User.by_token(@token).first
    end
    
    it "should reset the token field when a password is set" do
      @user.update_attribute(:password, "password123")
      assert_nil @user.reload.invitation_token
    end
  end

end
