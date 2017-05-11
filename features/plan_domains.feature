Feature: Plan Domains
  As a planner
  In order to determine my school's curriculum
  I want to plan from the list of available domains

  Scenario: View list of domains
    Given I am a registered planner
    And a curriculum exists
    When I sign in
    And I visit the domains page
    Then I should see a list of grades with curriculum
    When I follow the link to the Kindergarten domains
    Then I should see a list of domains for "Kindergarten"
    When I follow the first domain link
    Then I should see a list of curriculum for that domain for the grade "Kindergarten"

  @javascript
  Scenario: Select or omit domains
    Given I am a registered planner
    And a curriculum exists
    And I have set up my school
    When I sign in
    And I visit the curriculum planning page
    And I omit a domain
    Then that domain should be hidden

  @javascript
  Scenario: Plan list of domains
    Given I am a registered planner
    And a curriculum exists
    And I have set up my school
    When I sign in
    And I visit the curriculum planning page
    Then I should see a list of available domains for Kindergarten
    When I drag a domain on to the calendar
    Then that domain should be scheduled

  @javascript
  Scenario: Add custom domain
    Given I am a registered planner
    And a curriculum exists
    And I have set up my school
    When I sign in
    And I visit the curriculum planning page
    And I add a custom domain
    Then the custom domain should exist
    When I drag my custom domain to the calendar
    Then that domain should be scheduled
