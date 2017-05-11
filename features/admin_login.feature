Feature: Administrator Login
  In order to manage the entire site
  As an administrator
  I want to log in

  Scenario: Sign in
    Given I am a registered administrator
    When I sign in
    Then I should be signed in
