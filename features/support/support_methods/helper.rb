# frozen_string_literal: true

# returns an element from element_list.yml

def get_element(arg)
  dir_to_data = Dir.pwd + '/features/support'
  data = YAML.load_file("#{dir_to_data}/element_list.yml")
  data['ElementSet']["#{arg}"]
end

# returns data from data_list.yml
def get_data(arg)
  dir_to_data = Dir.pwd + '/features/support'
  data = YAML.load_file("#{dir_to_data}/data_list.yml")
  data['DataSet']["#{arg}"]
end

def login(username, password)
  visit '/login'
  fill_element_with_text('Email_Entry', get_data(username.to_s).to_s)
  fill_element_with_text('Password_Entry', get_data(password.to_s).to_s)

  click_on_element('Login_Button')

  wait_until_page_url_includes('/?login=1')
end

def drag_by_coordinates(right_by, down_by)
  page.driver.browser.action.drag_and_drop_by(native, right_by, down_by).perform
end

def raise_with_new_message(*args)
  ex = args.first.is_a?(Exception) ? args.shift : $!
  msg = begin
          format args.shift, *args
        rescue StandardError => e
          "internal error modifying exception message for #{ex}: #{e}"
        end
  screenshot = "fail#{rand(1..100)}.png"
  save_screenshot(screenshot, full: true)
  embed("screenshots/#{screenshot}", 'image/png', 'SCREENSHOT')
  raise ex, msg, ex.backtrace
end




