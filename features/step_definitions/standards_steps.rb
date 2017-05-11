Given "standards exist" do
  3.times { FactoryGirl.create :standard }
end

Given "I have uploaded a standards file" do
  Standard.import(CSV.read(File.join(Rails.root, 'doc', 'standards.csv'), :headers => true))
end

When /^I upload a standards file$/ do
  attach_file "File to upload", File.join(Rails.root, 'doc', 'standards.csv')
  click_button "Upload"
end

Then "I should see the standards" do
  Standard.all.each do |standard|
    assert page.has_content?(standard.text)
  end
end

Then /^the standards should exist$/ do
  assert Standard.count > 0
end
