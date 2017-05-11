Feature: Invite planner
  As an administrator
  In order for people to use my curriculum
  I want to invite planner users

  Scenario: Invite planner
    Given I am a registered administrator
    When I sign in
    And I visit the planner invitation page
    And I invite a new planner
    Then the planner should receive an email invitation

  Scenario: Accept invitation
    Given I am not a registered user
    And I have received a planner invitation
    When I follow the link in the invitation email
    And I enter a password
    Then I should be signed up as a planner
    
