require 'test_helper'

class SchoolTest < MiniTest::Spec

  it "should belong to planner" do
    @planner = FactoryGirl.create :user, :planner => true
    @school = FactoryGirl.create :school, :planner_id => @planner.id
    assert_equal @planner, @school.planner
    assert_equal @school, @planner.reload.school
  end

  it "should maintain a list of omitted domains" do
    @school = FactoryGirl.create :school
    @domain = FactoryGirl.create :domain
    assert @school.includes_domain?(@domain)
    @school.omit_domain!(@domain)
    refute @school.includes_domain?(@domain)
    @school.include_domain!(@domain)
    assert @school.includes_domain?(@domain)
  end

  it "should report a list of custom domain tags" do
    @school = FactoryGirl.create :school
    %w(Science Mathematics).each {|n| FactoryGirl.create :domain, :school => @school, :tag => n }
    assert_equal 2, @school.reload.custom_domain_tags.size
    assert @school.custom_domain_tags.include?("Science")
    assert @school.custom_domain_tags.include?("Mathematics")
  end

end
