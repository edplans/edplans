Feature: Manage School
  As a Planner
  In order to customize curriculum for my school
  I want to manage my school's information

  Scenario: Set school year
    Given I am a registered planner
    When I sign in 
    And I visit the manage school page
    And I set my school's year
    Then my school's year should have start and end dates

  @javascript
  Scenario: Add holidays
    Given I am a registered planner
    When I sign in
    And I visit the manage school page
    And I set my school's year
    And I add a holiday
    Then my school's year should have a holiday
