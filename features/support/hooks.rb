#encoding: UTF-8
After do |scenario|
  begin
    @recorder.stop unless @recorder.nil?
  rescue StandardError => e
    puts "could not stop recorder error: #{e}"
  end
  if scenario.failed?
    p 'scenario failed'
    # ScreenRecorder.ffmpeg_binary = File.join(Dir.pwd, 'ffmpeg.exe')
  else
    begin
      @recorder.discard
    rescue StandardError => e
      puts "could not discard recorder, error: #{e}"
    end
  end
end

Before do |scenario|
  @tags = scenario.source_tag_names # @tags instance variable accessible in test
  puts @tags[0]
  advanced = {
      input: {
          framerate: 30,
          video_size: '1280x480'
      },
      output: {
          r: 15 # Framerate
      },
      log: 'recorder.log',
      loglevel: 'level+debug', # For FFmpeg
  }
  @recorder = ScreenRecorder::Desktop.new(output: "videos/#{scenario.name.split.join('_')}.mp4", advanced: advanced)
  begin
    @recorder.start
  rescue StandardError => e
    puts "could not start recorder, error: #{e}"
  end
end

Before('@edge') do
  Capybara.current_driver = :edge_driver
end

After('@log_out') do
  hover_on_element('Person_Icon')

  click_visible_link('ÇIKIŞ')
  wait_until_page_url_includes('/?logout=1')
end

After('@mobile_log_out') do
  visit '/customer/info'
  click_on_element('Mobile_Account_Menu')
  click_visible_link('ÇIKIŞ')
  wait_until_page_url_includes('/?logout=1')
end

After('@clear_first_basket_item') do
  visit '/cart'

  click_on_element('Remove_From_Cart_Button')
  wait_for { page.has_text?('Seçilen ürün sepetinizden silinecektir. Onaylıyor musunuz ?') }

  click_visible_button('modal-btn-si')

  wait_for { page.has_text?('Alışveriş Sepetiniz Boş !') }
end

After('@clear_first_basket_item_mobile') do
  visit '/cart'
  click_on_element('Remove_From_Basket_Button')
  page.driver.browser.switch_to.alert.accept
  wait_until_elements_text_is_displayed('Empty_Cart_Page_Text', 'Alışveriş Sepetiniz Boş')
end

After('@clear_first_item_favorites') do
  visit '/customer/favouritesubscriptions'

  click_on_element('Remove_Favourited_Item_Button')

  wait_for { page.has_text?('Bu ürünü favorilerinizden cıkarmak istiyor musunuz?') }

  click_on_element('TAMAM_Button_In_Popup')

  wait_for { page.has_text?('Favori listenizde ürün bulunmamaktadır.') }
end

After('@clear_addresses') do
  visit '/customer/addresses'

  click_on_element('Remove_Button')
  wait_for { page.has_text?('Bu adresi silmek istediğinizden emin misiniz?') }
  click_on_element('TAMAM_Button_In_Popup')

  wait_until_element_is_displayed('No_Addresses_Info_Text')
end

After('@revert_to_old_password') do
  visit '/customer/changepassword'

  fill_element_with_text('Old_Password_Entry', get_data('New_Password').to_s)
  fill_element_with_text('New_Password_Entry', get_data('Valid_Password').to_s)
  fill_element_with_text('Confirm_New_Password_Entry', get_data('Valid_Password').to_s)

  click_visible_button('ŞİFRE DEĞİŞTİR')
  wait_for { page.has_text?('Şifreniz değişti') }
end

After('@revert_my_account_changes') do
  visit '/customer/info'

  fill_element_with_text('First_Name_Entry','Kaan')
  fill_element_with_text('Last_Name_Entry','Test')

  click_visible_button('save-info-button')

  wait_for { all('input[value="Kaan"]').size.positive? }
  wait_for { all('input[value="Test"]').size.positive? }
end



Before('@mobile') do
  page.driver.browser.manage.window.resize_to(414, 736)
end

Before('@mobile_2') do
  Capybara.current_driver = :chrome_mobile
  page.driver.browser.manage.window.maximize
end

Before('@desktop') do
  Capybara.current_driver = :selenium
end

Before('@desktophook') do
  page.driver.browser.manage.window.resize_to(1440, 900)
end


After('@close_browser') do
  page.driver.browser.close
end


Before('@headless') do
  Capybara.default_driver = :headless_chrome
end

Before('@login') do
  login('Valid_email', 'Valid_Password')
end

Before('@login_to_account_for_address') do
  login('Email_for_Address_case', 'Valid_Password')
end

Before('@login_to_account_for_add_favourite') do
  login('Email_for_Add_to_favourite_case', 'Valid_Password')
end

Before('@login_to_account_for_change_password') do
  login('Email_for_Change_Password_case', 'Valid_Password')
end

AfterStep('@adv_popup') do
  page.execute_script('$(".sp-fancybox-wrap").remove();')
  page.execute_script('$(".sp-fancybox-overlay").remove();')
  page.execute_script('$(".sp-fancybox-iframe").remove();')
  page.execute_script('$(".sp-fancybox-inner").remove();')
end

After('@clear_product_compare_list') do
  visit '/getcompareproducts'
  click_on_element('Remove_From_Comparison_List_Button_On_The_Left')
  click_on_element('Remove_From_Comparison_List_Button_On_The_Left')
  wait_until_element_is_displayed('No_Item_In_Product_Compare_List')
end

After('@clear_product_compare_list_and_basket_mobile') do
  visit '/getcompareproducts'
  click_on_element('Remove_From_Comparison_List_Button_On_The_Left')
  wait_until_element_is_displayed('No_Item_In_Product_Compare_List')
  visit '/cart'
  if page.has_css?(get_element('Remove_From_Cart_Button'), match: :first, wait: 5)
    click_on_element('Remove_From_Cart_Button')
    sleep 1
    click_visible_button('product-delete-yes')
  else
    puts 'sepette ürün bulunamadı'
  end
  wait_until_elements_text_is_displayed('Empty_Cart_Page_Text', 'Alışveriş Sepetin Boş')
end

After('@clear_price_alarm_list') do
  visit '/customer/pricesubscriptions'
  page.execute_script 'window.scrollBy(0,1000)'
  click_on_element('Delete_Price_Subscription_Button')
  accept_alert('Ürün fiyat bildirimi listenizden silinecektir. Onaylıyor musunuz ?', wait: 5)

  wait_until_element_is_displayed('No_Item_In_Price_Alarm_Page_Text')
end

AfterStep do |step|
  logs = page.driver.browser.manage.logs.get(:browser)
  severe_errors = logs.select { |log| log.level == 'SEVERE' }
  if severe_errors != []
    puts severe_errors
    source_url = page.current_url
    write_logs_to_file("#{logs} \n Source URL: #{source_url}")
  end
end

at_exit do
  send_severe_logs
  ReportBuilder.configure do |config|
    config.input_path = 'reports/process.json'
    config.report_path = 'results/report'
    config.report_types = [:retry, :html, :json]
    config.report_title = 'THE DEAL Web'
    config.additional_info = {Browser: 'Chrome', Environment: 'Live'}
  end
  if $ERROR_INFO.is_a? StandardError
    screenshot = "fail#{rand(1..100)}.png"
    save_screenshot(screenshot, full: true)
    embed("screenshots/#{screenshot}", "image/png", "SCREENSHOT")
  end
  ReportBuilder.build_report
end