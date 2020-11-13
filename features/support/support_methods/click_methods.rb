def click_on_element(locator)
  wait_randomly
  find(get_element(locator.to_s), match: :first, visible: true).click
rescue StandardError
  raise_with_new_message 'Unable to click on element'
end

## click all buttons with input or button tags. locator can be text, id or name
def click_visible_button(locator)
  wait_randomly
  click_button(locator.to_s, match: :first, visible: true)
rescue StandardError
  raise_with_new_message 'Unable to click on button'
end

## click all links. locator can be link text or id
def click_visible_link(locator)
  wait_randomly
  click_link(locator.to_s, match: :first, visible: true)
rescue StandardError
  raise_with_new_message 'Unable to click on link'
end

def click_element_with_text(locator, element_text)
  wait_randomly
  find(get_element(locator.to_s),
       text: element_text.to_s,
       match: :first,
       visible: true).click
rescue StandardError
  raise_with_new_message 'Unable to click on element with text'
end