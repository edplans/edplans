Feature: Manage Users
  As an administrator
  In order to control access to the application
  I want to manage users

  Scenario: Delete Users
    Given I am a registered administrator
    And registered users exist
    When I sign in
    And I visit the user management page
    And I delete a user
    Then that user should not exist
