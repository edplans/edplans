Feature: Standards
  As an administrator
  In order to associate national standards with the curriculum
  I want to manage the standards database

  Scenario: View Standards
    Given I am a registered administrator
    And standards exist
    When I sign in
    And I visit the standards management page
    Then I should see the standards
  
  Scenario: Upload CSV file of standards
    Given I am a registered administrator
    When I sign in
    And I visit the standards upload page
    And I upload a standards file
    Then the upload should succeed
    And the standards should exist

