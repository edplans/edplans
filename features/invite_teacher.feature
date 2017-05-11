Feature: Invite teacher
  As an planner
  In order for teachers from my school to use my plan
  I want to invite teacher users

  Scenario: Invite teacher
    Given I am a registered planner
    When I sign in
    And I visit the teacher invitation page
    And I invite a new teacher
    Then the teacher should receive an email invitation

  Scenario: Accept invitation
    Given I am not a registered user
    And I have received a teacher invitation
    When I follow the link in the invitation email
    And I enter a password
    Then I should be signed up as a teacher
    
