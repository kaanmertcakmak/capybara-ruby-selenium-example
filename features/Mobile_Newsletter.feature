Feature: Mobile | Newsletter - Sign up for newsletter successfully

  @mobile_2
  Scenario: Sign up for newsletter successfully
    Given I visit "/"
    And I click on "Newsletter_Gizlilik_Checkbox"
    And I fill following fields with following informations
    |Newsletter_Email|
    |kaan.cakmak@inveon.com|
    And I click on "newsletterButton" button
    And I wait for "1" seconds
    Then I verify "Kaydolduğunuz İçin Teşekkür Ederiz" is displayed as "text"