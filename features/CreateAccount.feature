Feature: User can manually create an account
  
Scenario Outline: Creating a new account
    Given I am not authenticated
    When I go to register
    And I fill in "user_first_name" with "<first_name>"
    And I fill in "user_last_name" with "<last_name>"
    And I fill in "user_email" with "<email>"
    And I fill in "user_password" with "<password>"
    And I fill in "user_password_confirmation" with "<password>"
    And I submit "#new_user"
    Then I should be on the home page
    And I should see "Welcome to Doing Together <first_name> <last_name>."

    Examples:
      | email               | password   | first_name | last_name |
      | testing@dotgthr.com | secretpass | Test       | User      |
      | foo@dotgthr.com     | fr33z3     | Francios   | Zapole    |