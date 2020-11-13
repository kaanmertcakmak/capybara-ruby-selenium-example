def wait_for
  wait = Selenium::WebDriver::Wait.new(timeout: 30)
  wait.until { yield }
rescue Selenium::WebDriver::Error::TimeoutError
  raise_with_new_message "Timeout"
end

# waits until input text is displayed on element
def wait_until_elements_text_is_displayed(element, text)
  wait_until_element_is_displayed(element)
  stored_text = get_element_text(element)
  expect(stored_text).to include(text.to_s)
rescue Selenium::WebDriver::Error::TimeoutError
  raise_with_new_message "Element text is not displayed"
end

# sleeps for random time between 0.5 - 2.5
def wait_randomly
  random_seconds = rand(0.5..2.5)
  sleep random_seconds
end

def wait_until_page_url_includes(url)

  wait_for { page.current_url.include?(url.to_s) }
rescue Selenium::WebDriver::Error::TimeoutError
  raise_with_new_message "Unable to find page url. Current url is #{page.current_url}"

end

def wait_until_page_has_text(text)

  wait_for { page.has_text?(text.to_s) }
rescue Selenium::WebDriver::Error::TimeoutError
  raise_with_new_message "Unable to find text = #{text}"

end

def wait_until_element_is_displayed(locator)
  wait_for { element_is_displayed?(locator) }
rescue Selenium::WebDriver::Error::TimeoutError
  raise_with_new_message "Unable to find element."
end