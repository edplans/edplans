Given "a curriculum exists" do
  @subject_areas = %w(Math Science Reading).map {|name| FactoryGirl.create :curriculum_node, :name => name}
  @grades = @subject_areas.map {|area| ["Kindergarten", "Grade 1", "Grade 2"].map {|name| FactoryGirl.create :curriculum_node, :name => name, :parent => area}}.flatten
  @grades.each do |grade|
    3.times do |n| 
      topic = FactoryGirl.create :curriculum_node, :parent => grade
      topic.domains = [ FactoryGirl.create(:domain, :grade => School.inverted_grades[grade.name]) ]
      FactoryGirl.create :guideline, :curriculum_node => topic
    end
  end
end

When /^I upload a curriculum file$/ do
  attach_file "File to upload", File.join(Rails.root, 'doc', 'kindergarten.csv')
  click_button "Upload"
end

When /^I upload a domain file$/ do
  attach_file "File to upload", File.join(Rails.root, 'doc', 'domains.csv')
  click_button "Upload"
end

When "I follow the first domain link" do
  within('table.domains') do
    @domain = Domain.where(:name => find('td a').text.gsub(/ \(.*days\)$/, '')).first
    click_link @domain.name
  end
end

When "I follow the link to the Kindergarten domains" do
  within('table.domains') do
    click_link "Kindergarten"
  end
end

Then "the upload should succeed" do
  refute page.has_content?("There was a problem importing your file.")
  assert page.has_content?("imported successfully!")
end

Then /^the curriculum should exist$/ do
  assert CurriculumNode.count > 0
  assert Guideline.count > 0
  assert StandardApplication.count > 0
end

Then /^the domains should exist$/ do
  assert Domain.count > 0
end

Then "I should see a list of grades with curriculum" do
  @grades.each do |grade|
    assert page.has_content?(grade.name)
  end
end

Then /^I should see a list of domains for "([^"]*)"$/ do |name|
  Domain.for_grade(School.inverted_grades[name]).all.each do |domain|
    assert page.has_content?(domain.name)
  end
end

Then /^I should see a list of curriculum for that domain for the grade "([^"]*)"$/ do |grade|
  grade = CurriculumNode.at_depth(1).where(:name => grade).first
  DomainApplication.where(:applicable_type => 'CurriculumNode', :applicable_id => grade.subtree_ids, :domain_id => @domain.id).all.map(&:applicable).each do |node|
    assert page.has_content?(node.name)
  end
end
