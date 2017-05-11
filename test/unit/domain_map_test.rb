require 'test_helper'

class DomainMapTest < MiniTest::Spec

  it "should belong to a school and a domain" do
    @school = FactoryGirl.create :school
    @domain = FactoryGirl.create :domain
    @map = FactoryGirl.create :domain_map, :school => @school, :domain => @domain
    assert_equal @school, @map.school
    assert_equal @domain, @map.domain
  end

  it "should contain a list of guidelines that have been mapped" do
    @map = FactoryGirl.create :domain_map
    @guideline = FactoryGirl.create :guideline
    @map.add_guideline! @guideline
    assert_equal [@guideline], @map.guidelines
  end

  it "should contain a list of skills-based guidelines that have been mapped" do
    @map = FactoryGirl.create :domain_map
    @guideline = FactoryGirl.create :guideline
    @map.add_skills_guideline! @guideline
    assert_equal [@guideline], @map.skills_guidelines
  end

  it "should contain a list of standards which are being omitted" do
    @map = FactoryGirl.create :domain_map
    @standard = FactoryGirl.create :standard
    @map.omit_standard! @standard
    assert_equal [], @map.included_standards
  end

  it "should contain a list of vocabulary words" do
    @map = FactoryGirl.create :domain_map
    @map.add_vocabulary! "Antidisestablishmentarianism"
    assert_equal ["Antidisestablishmentarianism"], @map.vocabulary
    @map.remove_vocabulary! "Antidisestablishmentarianism"
    assert_equal [], @map.vocabulary
  end

end
