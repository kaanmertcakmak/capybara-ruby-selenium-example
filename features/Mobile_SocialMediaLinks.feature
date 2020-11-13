Feature: Mobile | Social Media Links - Clicking social media icons in homepage
  and verifying if they are displaying correctly

  @mobile_2
  Scenario: Social media links are correctly addressed validation
    Given I visit "/"
    And I check social media links
      |instagram|
      |instagram.com/|

