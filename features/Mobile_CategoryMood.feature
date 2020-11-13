Feature: Mobile | Category Mood - Navigate to category by selecting mood

  @mobile_2
  Scenario: Navigate to category by selecting mood
    Given I visit "/"
    When I click on "Hemen_Kesfet_Button"
    Then I select a mood and verified if it redirects me to correct category