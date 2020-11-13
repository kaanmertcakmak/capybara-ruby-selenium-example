Feature: Mobile | Footer - Footer links are addressed true or not?

  @mobile_2
  Scenario: Checking if footer addresses are correct
    Given I visit "/"
    And I check footer links
      |Hikayemiz |Bize Ulaşın    |Sıkça Sorulan Sorular|
      |/#about-us|/common/support|/pages/sss           |
    And I click on "Privacy Policy" of "Footer_Bottom_Menu"
    Then I should be redirected to "/pages/gizlilik-sozlesmesi"
    And I click on "Terms of Service" of "Footer_Bottom_Menu"
    Then I should be redirected to "/pages/uyelik-sozlesmesi"


