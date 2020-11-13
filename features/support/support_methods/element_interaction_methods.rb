def hover_on_element(locator)
  find(get_element(locator.to_s), match: :first, visible: true).hover
rescue Selenium::WebDriver::Error::TimeoutError
  raise_with_new_message 'Unable to hover on element'
end

def get_element_text(locator)
  find(get_element(locator.to_s), match: :first, visible: true).text
rescue StandardError
  raise_with_new_message 'Unable to get element text'
end

def fill_element_with_text(locator, text)
  fill_in get_element(locator.to_s),
          match: :first,
          visible: true,
          with: text
rescue Selenium::WebDriver::Error::TimeoutError
  raise_with_new_message 'Unable to fill element with text'
end

# locator is element's name in element_list.yml and option is text or value
def select_option_from_element(option, locator)
  select option,
         from: get_element(locator.to_s),
         match: :first,
         visible: true
rescue Selenium::WebDriver::Error::TimeoutError
  raise_with_new_message 'Unable to select'
end

def element_is_displayed?(locator)
  all(get_element(locator.to_s),
      match: :first,
      visible: true).size.positive?
rescue Selenium::WebDriver::Error::TimeoutError
  raise_with_new_message "#{get_element(locator.to_s)} element is not displayed"
end
