Feature: Mobile | Guest Checkout - User tries to purchase product successfully via guest checkout and havale

  @mobile_2 @clear_first_basket_item
  Scenario: User tries to purchase product successfully
    Given I visit "/"
    When I created my own blend
    And I add product to the Cart and verified if product is into Cart successfully
    And I click on "checkout_trigger" button
    Then I should be redirected to "/login/checkoutasguest?returnUrl=%2Fcart"
    And I click on "ÜYE OLMADAN SATIN AL" button
    Then I should be redirected to "/checkout/opc"
    And I click on "Add_New_Address_Button_Checkout"
    And I fill following fields with following informations
      |First_Name_Entry|Last_Name_Entry|Email_Entry                   |Phone_Number_Entry|Address_Entry_2    |
      |Kaan            |test           |kaan.cakmak@changepassword.com|5387777675        |test test test test|
    And I select following options from following dropdowns
      |Customer_City_Selection_Dropdown|Customer_County_Selection_Dropdown|
      |İSTANBUL                        |KADIKÖY                          |
    And I click on "Add_Address_Button_In_Checkout"
    Then I verify "Kaan test" is displayed in "Address_Name_Text" element
    And I wait for "3" seconds
    And I click on "Ödeme Adımına Geç" button
    And I enter payment informations
    And I click on "Next_Step_To_Summary"
    And I check Siparis Ozeti and verified Order Informations are Correct
    And I check if policies are displayed correctly and complete order
    Then I should be redirected to proper 3D secure page
