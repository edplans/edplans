require 'test_helper'

class ScheduledDomainTest < MiniTest::Spec

  it "should belong to a school, a domain, and a subject" do
    @school = FactoryGirl.create :school
    @domain = FactoryGirl.create :domain
    @subject = FactoryGirl.create :curriculum_node
    @scheduled_domain = FactoryGirl.create :scheduled_domain, :school => @school, :domain => @domain, :subject => @subject
    assert_equal @school, @scheduled_domain.school
    assert_equal @domain, @scheduled_domain.domain
    assert_equal @subject, @scheduled_domain.subject
  end

  it "should report its domain's name" do
    @domain = FactoryGirl.create :domain, :name => "Domain Name"
    @scheduled_domain = FactoryGirl.create :scheduled_domain, :domain => @domain
    assert_equal "Domain Name", @scheduled_domain.domain_name
  end

end
