Feature: Desktop | Product Detail - Checking product detail page contents
  
  Scenario: Checking product detail page contents
    Given I visit "/calm-lake"
    Then I should be redirected to "/calm-lake"
    Then I verify "Dur. Dinle, doğanın sesleri sakinleştirir. Papatya, melisa, passiﬂora ve ıhlamurun mükemmel ahengiyle rahatla." is displayed as "text"
    Then I verify "Product_Heat_Field" is displayed
    Then I verify "Product_Amount_Field" is displayed
    Then I verify "Product_Time_Field" is displayed
    Then I verify "Spotify_Player" is displayed
