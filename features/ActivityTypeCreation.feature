Feature: User can manually add an activity type
  
Scenario: Add an activity type
  Given I am a new, authenticated user
  Then I should be on the home page
  Given I am on the ActivityType Page
  Then save me the page
  When I press "Register New Activity Type"
  And I fill in "activitytypes_name" with "Capturing a Jaguar"
  And I fill in "activitytypes_score" with "1.15"
  And I press "Create New Activity Type"
  Then I should be on the ActivityType Page
  And I should see "Capturing a Jaguar"