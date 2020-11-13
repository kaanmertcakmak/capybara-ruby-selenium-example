# frozen_string_literal: true

And(/^I visit "([^"]*)"$/) do |arg|
  visit "#{arg}"
end

Then(/^I should be redirected to "([^"]*)"$/) do |arg|
  wait_until_page_url_includes(arg.to_s)
end

And(/^I "([^"]*)" address with following informations$/) do |arg, table|
  # table is a table.hashes.keys # => [:Kaan, :Cakmak, :kaan.cakmak@inveon.com, :(538)-777-7675, :Türkiye, :İSTANBUL, :KADIKÖY, :Inveon Levent Mat.]
  informations = table.raw[0]
  if arg == 'add'
    click_on_element('Add_New_Address_Button')

    wait_until_page_url_includes('/customer/addressadd')

    fill_element_with_text('Address_First_Name_Entry', informations[0])
    fill_element_with_text('Address_Last_Name_Entry', informations[1])
    fill_element_with_text('Address_Email_Entry', informations[2])
    fill_element_with_text('Address_Phone_Number_Entry', informations[3])

    select_option_from_element(informations[4], 'Address_City_Selection_Dropdown')
    select_option_from_element(informations[5], 'Address_County_Selection_Dropdown')

    fill_element_with_text('Address_Entry', informations[6])

    click_on_element('Kaydet_Button')

    wait_until_elements_text_is_displayed('First_Address_Title', 'Kaan test')
  elsif arg == 'edit'
    click_on_element('Edit_Address_Button')

    wait_until_page_url_includes('/customer/addressedit/')

    fill_element_with_text('Address_First_Name_Entry', informations[0])
    fill_element_with_text('Address_Last_Name_Entry', informations[1])
    fill_element_with_text('Address_Entry', informations[2])

    click_visible_button('KAYDET')

    wait_until_elements_text_is_displayed('First_Address_Title',
                                          'Cakmak Cakmak')
    wait_until_elements_text_is_displayed('Address_Section_Text',
                                          'Edited Test Address')
  end
end

When(/^I close iframe$/) do
  if page.has_css?('.sp-fancybox-iframe', visible: true, wait: 5)
    within_frame(find('.sp-fancybox-iframe')) do
      sleep 0.5
      find('.fa-times.element-close-button').click
    end
  else
    sleep 2
  end
end

When(/^I navigate "([^"]*)" category$/) do |arg2|
  if @tags.include?('@mobile_2')
    click_visible_button('mobileMenuTrigger')
    click_element_with_text('Category_Menus_Mobile', arg2)
  else
    click_element_with_text('Category_Menus', arg2)
  end
end

And(/^I navigate into one of the category pages$/) do
  if @tags.include?('@mobile_2')
    click_on_element('Category_Menus_Mobile')
    categories = all(get_element('Category_Menus'), visible: true)
    random_num = rand(categories.length)
    categories[random_num].click
  else
    categories = all(get_element('Category_Menus'), visible: true)
    random_num = rand(categories.length)
    categories[random_num].click
    if element_is_displayed?('No_Stock_Badge')
      step 'I navigate into one of the category pages'
    else
      sleep 0.5
    end
  end

end

And(/^I navigate into one of the product detail pages$/) do
  wait_until_element_is_displayed('Product_Name')
  product_names = all(get_element('Product_Name'))
  random_number = rand(product_names.length)
  sleep 1
  product_names[random_number].click
  if page.has_css?(get_element('Add_To_Cart_Button'), visible: true, wait: 5)
    @product_name = get_element_text('Product_Name_In_Product_Detail')
  else
    page.go_back
    step 'I navigate into one of the product detail pages'
  end
end

Then(/^I verify "([^"]*)" is displayed(?: as "(.*)")?$/) do |arg, arg2|
  if arg2 == 'xpath'
    wait_for { all(:xpath, get_element(arg), match: :first).size.positive? }
    expect(page).to have_selector(:xpath, get_element(arg))
  elsif arg2 == 'text'
    wait_for { page.has_text?(arg.to_s) }
  else
    wait_until_element_is_displayed(arg)
    expect(page).to have_selector(get_element(arg))
  end
end

And(/^I (?:click|selected) (?:on|in) "([^"]*)"(?: in "(.*)")?$/) do |arg, arg2|
  if arg2 == 'iframe'
    within_frame(find('.sp-fancybox-iframe')) do
      sleep 0.2
      find(get_element(arg), match: :first).click
    end
  elsif arg2 == 'jquery'
    sleep 0.2
    page.execute_script("$('#{get_element(arg)}').click();")
  elsif arg2 == 'javascript'
    sleep 0.2
    page.execute_script("document.getElementById('#{get_element(arg)}').click();")
  else
    sleep 0.2
    find(get_element(arg), match: :first, visible: true).click
  end
end

And(/^I click on "([^"]*)" link$/) do |arg|
  click_visible_link(arg.to_s)
end

And(/^I click on "([^"]*)" if it is displayed$/) do |arg|
  if page.has_css?(get_element(arg.to_s), visible: true, wait: 5)
    click_on_element(arg.to_s)
  else
    sleep 1
  end
end

And(/^I login successfully with following credentials$/) do |table|
  # table is a table.hashes.keys # => [:kaan.cakmak@address.com, :Test1234]
  informations = table.raw[0]
  fill_element_with_text('Email_Entry', informations[0])
  fill_element_with_text('Password_Entry', informations[1])

  click_visible_button('GİRİŞ YAP')
end

Then(/^I navigate to Favorilerim page and verified if product is added to favourites list successfully$/) do
  sleep 2
  wait_until_elements_text_is_displayed('Alert_Message_Text',
                                        'İlgili ürün favori listenize eklenmiştir')
  sleep 1
  click_on_element('Close_Favorite_popup')

  if @tags.include?('@mobile_2')
    click_visible_button('mobileMenuTrigger')
    sleep 1
    click_on_element('HESABIM')

    wait_until_page_url_includes('/customer/info')

    click_on_element('Mobile_Account_Menu')

    click_visible_link('Favori Listem')
  else
    hover_on_element('Person_Icon')

    click_visible_link('Favorilerim')
  end
  wait_until_page_url_includes('/customer/favouritesubscriptions')
  name_of_favourited_product = get_element_text('Favourited_Product_Name')

  expect(name_of_favourited_product.downcase).to include(@product_name.downcase)
end

And(/^I add product to the Cart and verified if product is into Cart successfully$/) do
  sleep 1
  click_on_element('Add_To_Cart_Button')

  if page.has_css?('Alert_Text_Popup', visible: true, wait: 5) && find(get_element('Alert_Text_Popup'), visible: true, wait: 5).text.include?('ürünümüz şuan stokta bulunmamaktadır.')
    step 'I navigate into one of the product detail pages'
    step 'I add product to the Cart and verified if product is into Cart successfully'
  else
    if @tags.include?('@mobile_2')
      sleep 0.5
      click_on_element('Sepet_Icon_Mobile')
    else
      element_in_mini_cart = get_element_text('Product_Name_In_Mini_Cart')
      expect(element_in_mini_cart.downcase).to include(@product_name.downcase)
      click_on_element('Alisveris_Cantama_Git')
    end
    wait_until_page_url_includes('/cart')
    name_of_product_in_cart = get_element_text('Product_Name_In_Cart')
    expect(name_of_product_in_cart.downcase).to include(@product_name.downcase)
  end
end

And(/^I increased product count and validated if the price is increased$/) do
  first_price = get_element_text('Total_Price').to_f
  puts first_price
  click_visible_button('+')

  sleep 0.5
  second_price = get_element_text('Total_Price').to_f
  puts second_price
  wait_for { expect(second_price).to be >= first_price }
end

And(/^I enter "([^"]*)" into "([^"]*)" field$/) do |arg1, arg2|
  sleep 1
  element = find(:id, get_element(arg2))
  if arg1 == 'Random_Phone_Number'
    random_phone_number = rand(5_050_000_000...5_556_075_409)
    random_phone_number.to_s.each_char do |c|
      element.send_keys c
      sleep 0.3
    end
  else
    input = arg1.to_s
    input.each_char do |c|
      element.send_keys c
      sleep 0.3
    end
  end
end

When(/^I navigate to "([^"]*)" page in Account Menu$/) do |arg|
  click_on_element('Person_Icon')
  click_visible_link(arg.to_s)
end

And(/^I fill following fields with following informations$/) do |table|
  fields = table.raw[0]
  informations = table.raw[1]

  i = 0
  while i < fields.length
    if informations[i] == 'Random_Email'
      time = Time.new
      puts time.year + time.month + time.day + time.usec
      generated_value = time.year.to_s + time.month.to_s + time.day.to_s + time.usec.to_s
      sleep 0.5
      fill_element_with_text(fields[i].to_s, generated_value.to_s + '@loadtest.com')
    else
      sleep 0.5
      fill_element_with_text(fields[i].to_s, informations[i])
    end
    i += 1
  end
end

And(/^I click on "([^"]*)" button$/) do |arg|
  click_visible_button(arg.to_s)
end

And(/^I wait for "([^"]*)" seconds$/) do |arg|
  sleep arg.to_i
end

Then(/^I close the browser tab$/) do
  page.driver.browser.close
end

And(/^I verify "([^"]*)" is displayed in "([^"]*)" element$/) do |arg1, arg2|
  wait_until_elements_text_is_displayed(arg2, arg1)
end

And(/^Following messages should appear$/) do |table|
  # table is a table.hashes.keys # => []
  messages = table.raw[0]
  i = 0
  while i < messages.length
    wait_until_page_has_text(messages[i])
    i += 1
  end
end

And(/^I select following options from following dropdowns$/) do |table|
  dropdowns = table.raw[0]
  selections = table.raw[1]

  i = 0
  while i < dropdowns.length
    select_option_from_element(selections[i].to_s, dropdowns[i].to_s)
    sleep 1
    i += 1
  end
end

And(/^I selected "([^"]*)" from "([^"]*)"(?: in "(.*)")?$/) do |arg1, arg2, arg3|
  if arg3 == 'mobile'
    sleep 0.5
    find(get_element(arg2), match: :first).find(get_element(arg1), match: :first).select_option
  elsif arg3 == 'desktop'
    find(get_element(arg2), text: arg1.to_s, match: :first).select_option
  else
    sleep 0.5
    select_option_from_element(arg1, arg2)
  end
end

And(/^I should see "([^"]*)" are sorted as "([^"]*)"$/) do |element, arg|
  prices = all(get_element(element.to_s))
  length_of_prices = prices.length
  arr = []
  prices.each do |x|
    arr << x.text.delete(' TL').delete('.').to_f
  end
  array_alphabetical = []
  prices.each do |x|
    array_alphabetical << x.text.downcase.to_s
  end
  if arg == 'low to high'
    puts arr[0..length_of_prices]
    puts arr[0..length_of_prices].sort
    expect(arr[0..length_of_prices].sort).to eq(arr[0..length_of_prices])
  elsif arg == 'high to low'
    puts arr[0..length_of_prices]
    puts arr[0..length_of_prices].sort.reverse
    expect(arr[0..length_of_prices].sort.reverse).to eq(arr[0..length_of_prices])
  elsif arg == 'A to Z'
    puts array_alphabetical[0..length_of_prices]
    puts array_alphabetical[0..length_of_prices].sort
    expect(array_alphabetical[0..length_of_prices].sort).to eq(array_alphabetical[0..length_of_prices])
  elsif arg == 'Z to A'
    puts array_alphabetical[0..length_of_prices]
    puts array_alphabetical[0..length_of_prices].sort.reverse
    expect(array_alphabetical[0..length_of_prices].sort.reverse).to eq(array_alphabetical[0..length_of_prices])
  end
end

And(/^I check Siparis Ozeti and verified Order Informations are Correct$/) do
  wait_until_elements_text_is_displayed('Shipping_Address_Title_In_Siparis_Ozeti', 'Kaan test')
  wait_until_elements_text_is_displayed('Billing_Address_Title_In_Siparis_Ozeti', 'Kaan test')
end

And(/^I check if policies are displayed correctly and complete order$/) do
  click_on_element('Mesafeli_Satis_Sozlesmesi_Opener')

  wait_until_elements_text_is_displayed('Satis_Container_Title', 'MESAFELİ SATIŞ SÖZLEŞMESİ')

  click_on_element('On_Bilgilendirme_Formu_Opener')

  wait_until_elements_text_is_displayed('Terms_Container_Title', 'TÜKETİCİ MEVZUATI GEREĞİNCE ÖN BİLGİLENDİRME FORMU')


  sleep 0.5
  page.execute_script 'document.getElementById("customCheckTerm2").click();'
  page.execute_script 'document.getElementById("customCheckTerm1").click();'

  click_visible_button('SİPARİŞİ TAMAMLA')
end

And(/^I applied "([^"]*)" filter$/) do |arg1|
  if @tags.include?('@mobile_2')
    click_on_element('Filter_Slider_Opener_Mobile')
    click_on_element(".filter-dropdown-menu .dropdown-toggle.#{arg2}")
    click_on_element(".filter-dropdown-menu .dropdown-menu li[title=\"#{arg1}\"]")
  else
    click_on_element("li[title=\"#{arg1}\"]")
  end
end

And(/^I click on "([^"]*)" of "([^"]*)"$/) do |text, element|
  click_element_with_text(element, text)
end

And(/^I should see listed "([^"]*)" are in between "([^"]*)" and "([^"]*)"$/) do |element,minimum,maximum|
  list = all(get_element(element).to_s)
  length = list.length
  arr = []
  list.each do |x|
    arr << x.text.to_i
  end
  puts "minimum number: #{arr[0..length].min.to_i}"
  expect(minimum.to_i).to be <= arr[0..length].min.to_i
  puts "maximum number: #{arr[0..length].max.to_i}"
  expect(maximum.to_i).to be >= arr[0..length].max.to_i
end



And(/^I check footer links$/) do |table|
  # table is a table.hashes.keys # => [:Hakkımızda, :İletişim, :SSS, :Gizlilik Politikası, :Değişim ve İade, :Mağazalar, :Private Card]
  table_texts = table.raw[0]
  table_urls = table.raw[1]
  puts table_texts
  puts table_urls
  links_Length = table_texts.length
  j = 0
  while j < links_Length
    sleep 0.5
    find(get_element('Footer_Links').to_s,
         text: "#{table_texts[j]}",
         visible: true, match: :first).click
    wait_until_page_url_includes(table_urls[j].to_s)
    expect(page.current_url).to include(table_urls[j])
    j += 1
  end
end

Then(/^I should see changed fields are updated properly$/) do
  wait_for { all('input[value="Qa"]').size.positive? }
  wait_for { all('input[value="Kaan"]').size.positive? }
end

Then(/^I navigate to Sepetime page via Mini Cart$/) do
  if @tags.include?('@mobile_2')
    click_on_element('Sepet_Icon')
  else
    hover_on_element('Sepet_Icon')
    product_name_in_mini_cart = get_element_text('Product_Name_In_Mini_Cart')
    expect(product_name_in_mini_cart).to include(@product_name)
    click_on_element('Alisveris_Cantama_Git')
  end
end

Then(/^I verify if policies in Sign Up page are displaying correctly$/) do
  click_on_element('Uyelik_Sozlesmesi_Opener')
  wait_until_elements_text_is_displayed('Uyelik_Sozlesmesi_Popup_Header',
                                            'KULLANIM KOŞULLARI')

  click_on_element('Close_Terms')

  click_on_element('KVKK_Opener')
  wait_until_elements_text_is_displayed('KVKK_Text',
                                            'Kişisel verilerin korunması')
  click_on_element('Close_Terms')
end

And(/^I check social media links$/) do |table|
  table_texts = table.raw[0]
  table_urls = table.raw[1]
  puts table_texts
  puts table_urls

  linksLength = table_texts.length
  j = 0
  while j < linksLength do
    sleep 0.5
    find("a[data-metrics='FooterSocialLinks|Click|#{table_texts[j]}']").click
    handle = page.driver.browser.window_handles
    page.driver.browser.switch_to.window(handle.last)
    wait_until_page_url_includes(table_urls[j].to_s)
    expect(page.current_url).to include(table_urls[j])
    puts page.current_url
    page.driver.browser.close
    page.driver.browser.switch_to.window(handle.first)
    j += 1
  end
end

Then(/^I should see product is added to the Price Alarm list$/) do
  product_name_in_price_alarm = get_element_text('Favourited_Product_Name')
  expect(@product_name).to include(product_name_in_price_alarm)
end

And(/^I refresh the page$/) do
  page.refresh
end


And(/^I check product sharing options$/) do |table|
  # table is a table.hashes.keys # => [:Facebook'ta paylaş, :Twitter'da paylaş, :WhatsApp'ta paylaş]
  sharing_options = table.raw[0]
  urls = table.raw[1]
  i = 0
  while i < sharing_options.length
    sleep 0.5
    find(".jssocials-share-#{sharing_options[i]}",
         match: :first,
         visible: true).click
    handle = page.driver.browser.window_handles
    page.driver.browser.switch_to.window(handle.last)
    wait_until_page_url_includes(urls[i].to_s)
    puts page.current_url
    page.driver.browser.close
    page.driver.browser.switch_to.window(handle.first)
    i += 1
  end
end

And(/^I close the browser and return back to first tab$/) do
  handle = page.driver.browser.window_handles
  page.driver.browser.close
  page.driver.browser.switch_to.window(handle.first)
end

When(/^I search for "([^"]*)"$/) do |arg|
  if @tags.include?('@mobile_2')
    click_on_element('Search_Icon')
    fill_element_with_text('Search_Entry', arg.to_s)
    find(:id, get_element('Search_Entry')).send_keys :enter
  else
    click_on_element('Search_Icon')
    fill_element_with_text('Search_Entry', arg.to_s)
    find(get_element('Search_Entry_2'),
         match: :first,
         visible:true).send_keys :enter
  end
end

And(/^I add product to the Cart in (favorites|price alarm) page and verified if product is into Cart successfully$/) do |arg|
  click_on_element('SEPETE_EKLE_Button')

  if page.has_css?('Alert_Text_Popup', visible: true, wait: 5) && find(get_element('Alert_Text_Popup'), visible: true, wait: 5).text.include?('ürünümüz şuan stokta bulunmamaktadır.')
    step 'I navigate into one of the product detail pages'
    step 'I add product to the Cart in favorites page and verified if product is into Cart successfully'
  else
    click_on_element('Sepet_Icon')
    wait_until_page_url_includes('/cart')
    name_of_product_in_cart = get_element_text('Product_Name_In_Cart')
    expect(name_of_product_in_cart.downcase).to include(@product_name.downcase)
  end
end

Then(/^Following names should be displayed on following elements$/) do |table|
  elements = table.raw[0]
  names = table.raw[1]

  i = 0
  while i < elements.length
    expect(get_element_text(elements[i])).to include(names[i])
    i += 1
  end
end

And(/^I applied following filters$/) do |table|
  filters = table.raw[0]

  i = 0
  while i < filters.length
    click_on_element("li[title='#{filters[i]}']")
    i += 1
  end
end

And(/^I add product to cart from Category page and verified if it is added successfully$/) do
  product_names = all(get_element('Product_Name'), visible: true)
  random_number = rand(product_names.length)
  sleep 1
  selected_product_name = product_names[random_number].text
  product_names[random_number].hover

  click_on_element('Add_To_Cart_Button_In_Product_Box')
  element_in_mini_cart = get_element_text('Product_Name_In_Mini_Cart')
  expect(element_in_mini_cart).to include(selected_product_name)
  click_on_element('Sepet_Icon')
  wait_until_page_url_includes('/cart')
  name_of_product_in_cart = get_element_text('Product_Name_In_Cart')
  expect(name_of_product_in_cart.downcase).to include(selected_product_name.downcase)
end

And(/^I scroll down$/) do
  page.execute_script 'window.scrollBy(0,700)'
end

Then(/^I verify Price Subscription info alert text is displayed$/) do
  accept_alert('İlgili ürün indirime girdiğinde sizleri bilgilendireceğiz. İlginiz için teşekkürler.', wait: 5)
end

And(/^I enter my wished price and add product to the price list$/) do
  price_in_price_wish_box = find(:id, get_element('Price_Alarm_Entry'),
                                 match: :first,
                                 visible: true).value.to_f
  my_wish_price = price_in_price_wish_box / 2
  fill_element_with_text('Price_Alarm_Entry', my_wish_price.to_i)
  click_on_element('Kaydet_subscription_price')
  accept_alert('İlgili ürün indirime girdiğinde sizleri bilgilendireceğiz. İlginiz için teşekkürler.', wait: 5)
end

And(/^I opened "([^"]*)" tab in product detail page$/) do |arg|
  if @tags.include?('@mobile_2')
    click_element_with_text('Product_Detail_Tabs_Mobile', arg)
  else
    find("a[data-metrics='ProductDetail|ClickTab|#{arg}']",
         match: :first,
         visible: true).click
  end
end

And(/^I clicked on Urune git button and verified if I could successfully navigated to product$/) do
  name_of_favourited_product = get_element_text('Favourited_Product_Name')
  click_on_element('URUNE_GIT')
  expect(name_of_favourited_product.downcase).to include(@product_name.downcase)
end

When(/^I created my own blend$/) do
  click_on_element('Kendi_Harmanini_Hazirla')
  wait_until_elements_text_is_displayed('Blending_Page_Title', 'Kendi harmanını hazırla!')
  wait_until_element_is_displayed('Journey_Box')
  mood_boxes = all(get_element('Journey_Box'), visible: true)
  random_num = rand(mood_boxes.length).to_i
  puts random_num
  wait_randomly
  mood_boxes[random_num].click
  if @tags.include?('@mobile_2')
    click_visible_button('scroll_1')
  else
    wait_for { page.has_text?('Önce çay bazını seçin.') }
  end
  wait_until_element_is_displayed('Tea_Box')

  tea_boxes = all(get_element('Tea_Box'), visible: true)
  random_num_tea = rand(tea_boxes.length).to_i
  puts random_num_tea
  sleep 1
  tea_boxes[random_num_tea].click
  if @tags.include?('@mobile_2')
    sleep 0.5
    find(:id, 'scroll_5', match: :first, visible: true).click
  else
    sleep 0.5
  end
  sleep 1
  wait_until_element_is_displayed('Taste_Box')
  taste_boxes = all(get_element('Taste_Box'), visible: true)
  random_num_taste = rand(taste_boxes.length).to_i
  puts random_num_taste
  selected_taste_id = page.execute_script("document.getElementsByClassName('taste-direction-box')[#{random_num_taste}].getAttribute('data-product-id')")
  puts selected_taste_id

  wait_randomly
  taste_boxes[random_num_taste].click

  wait_until_page_url_includes("/Product/ProductDetails?productId=#{selected_taste_id}")

  if page.has_css?(get_element('Add_To_Cart_Button'), visible: true, wait: 5)
    @product_name = get_element_text('Product_Name_In_Product_Detail')
  else
    visit '/'
    step 'I navigate into one of the product detail pages'
  end
end

Then(/^I select a mood and verified if it redirects me to correct category$/) do
  wait_until_elements_text_is_displayed('Mood_Selection_Page', '1. ÇAY SEÇİMİ')

  click_visible_button('SEÇ')
  wait_until_element_is_displayed('Mood_Option')
  mood_options = all(get_element('Mood_Option'), visible: true)
  random_num = rand(mood_options.length).to_i
  puts random_num
  sleep 1
  elements_link = mood_options[random_num][:href]
  puts elements_link
  mood_options[random_num].click
  if @tags.include?('@mobile_2')
    click_on_element('Complete_Selection_Mood')
  else
    sleep 0.5
  end
  wait_until_page_url_includes(elements_link)
end

And(/^I enter payment informations$/) do
  garanti = %w[Garanti_Card_Number Garanti_Card_holder_name Garanti_Expire_Month Garanti_Expire_Year Garanti_CVC]
  isbank = %w[Is_Bankasi_Card_Number Is_Bankasi_Card_holder_name Is_Bankasi_Expire_Month Is_Bankasi_Expire_Year Is_Bankasi_CVC]
  finans = %w[Finans_Card_Number Finans_Card_holder_name Finans_Expire_Month Finans_Expire_Year Finans_CVC]
  credit_cards = [garanti, isbank, finans]
  random_index = rand(credit_cards.length).to_i
  puts random_index
  @selected_card = credit_cards[random_index]
  puts @selected_card
  sleep 1
  credit_card_input = get_data(@selected_card[0]).to_s
  credit_card_input.each_char do |c|
    find(:fillable_field, get_element('Card_Number_Entry').to_s).send_keys c
    sleep 0.1
  end
  fill_element_with_text('Card_Holder_Name_Entry', get_data(@selected_card[1]).to_s)
  puts @selected_card[2]
  puts get_data(@selected_card[2])
  select_option_from_element(get_data(@selected_card[2].to_s), 'Expire_Month_Selection_Dropdown')
  select_option_from_element(get_data(@selected_card[3].to_s), 'Expire_Year_Selection_Dropdown')
  fill_element_with_text('CVC_Entry', get_data(@selected_card[4]).to_s)
end

Then(/^I should be redirected to proper 3D secure page$/) do
  puts @selected_card[0]
  case @selected_card[0]
  when 'Garanti_Card_Number'
    wait_until_page_url_includes('https://3dsecure.garanti.com.tr/')
    wait_until_page_has_text('Uluslararası Güvenlik Platformu 3D Secure')
  when 'Is_Bankasi_Card_Number'
    wait_until_page_url_includes('https://maxinet.isbank.com.tr/')
    wait_until_page_has_text('Maximum Mobil ile Doğrula')
  when 'Finans_Card_Number'
    wait_until_page_url_includes('https://goguvenliodeme.bkm.com.tr/')
    wait_until_page_has_text('Doğrulama kodunu giriniz')
  else
    sleep 0.5
  end
end