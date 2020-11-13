Feature: Desktop | Forget Password page - User tries to send forget password email

  Scenario: User tries to send an email with empty inputs
    Given I visit "/"
    When I click on "Person_Icon"
    Then I should be redirected to "/login"
    And I click on "Şifremi Unuttum" link
    Then I should be redirected to "/passwordrecovery"
    And I click on "SIFREMI_GONDER"
    Then Following messages should appear
    |Email adresinizi giriniz|
    When I fill following fields with following informations
      |Email_Entry|
      |kmc        |
    And I click on "SIFREMI_GONDER"
    Then Following messages should appear
      |Hatalı E-posta|
    When I fill following fields with following informations
      |Email_Entry|
      |kaan@gmail.com|
    And I click on "SIFREMI_GONDER"
    Then Following messages should appear
      |Sistemimizde kayıtlı e-posta adresi bulunamamıştır. Lütfen tekrar deneyiniz|
    When I fill following fields with following informations
      |Email_Entry|
      |kaan.cakmak@inveon.com|
    And I click on "SIFREMI_GONDER"
    Then Following messages should appear
      |Şifre değişiklik bilgileriniz e-posta adresinize gönderildi.|