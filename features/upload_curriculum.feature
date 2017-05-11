Feature: Upload curriculum
  As an administrator
  In order to manage curriculum
  I want to upload a file

  Scenario: Upload CSV file of curriculum
    Given I am a registered administrator
    And I have uploaded a standards file
    When I sign in
    And I visit the curriculum management page
    And I upload a curriculum file
    Then the upload should succeed
    And the curriculum should exist

  Scenario: Upload CSV file of domains
    Given I am a registered administrator
    When I sign in
    And I visit the domain management page
    And I upload a domain file
    Then the upload should succeed
    And the domains should exist

  Scenario: Attempt to manage curriculum without privileges
    Given I am a registered user
    When I sign in
    And I visit the curriculum management page
    Then I should not be authorized
