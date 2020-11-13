# encoding: UTF-8
require 'cucumber'
require 'rspec'
require 'selenium-webdriver'
require 'capybara'
require 'capybara/dsl'
require 'rest-client'
require 'headless'
require 'bigdecimal'
require 'bigdecimal/util'
require 'rails-dom-testing'
require 'rails'
require 'jquery-rails'
require 'jquery'
require 'ffi'
require 'screen-recorder'
require 'pony'
require 'report_builder'
require 'streamio-ffmpeg'


file_patterns = ['videos/*.mkv']
file_patterns.each do |p|
  Dir.glob(p) { |f| File.delete(f) if File.exist?(f) }
end
Capybara.save_path = File.expand_path(File.join(File.dirname(__FILE__), '../../screenshots/'))
FileUtils.rm_rf('screenshots') if File.exist?('screenshots')

File.truncate('logs.csv', 0) if File.exist?('logs.csv')
Capybara.register_driver :selenium do |app|
  profile = Selenium::WebDriver::Chrome::Profile.new
  client = Selenium::WebDriver::Remote::Http::Default.new
  client.read_timeout = 240 # instead of the default 60
  Capybara::Selenium::Driver.new(app,
                                 browser: :chrome,
                                 profile: profile,
                                 http_client: client,
                                 args: %w[--start-maximized])
end

Capybara.register_driver :edge_driver do |app|
  options = Selenium::WebDriver::Edge::Options.new
  client = Selenium::WebDriver::Remote::Http::Default.new
  client.read_timeout = 240 # instead of the default 60
  Selenium::WebDriver::Edge::Service.driver_path = File.join(Dir.pwd, 'msedgedriver.exe')
  Capybara::Selenium::Driver.new(app,
                                 options: options,
                                 browser: :edge)
end

FFMPEG.ffmpeg_binary = File.join(Dir.pwd, 'ffmpeg.exe')
ScreenRecorder.ffmpeg_binary = File.join(Dir.pwd, 'ffmpeg.exe')





# Run tests or whatever you want to record



Capybara.register_driver :chrome320x480 do |app|
  args = []
  args << '--window-size=414,736'
  # you can also set the user agent
  args << "--user-agent='Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X)
AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3'"
  client = Selenium::WebDriver::Remote::Http::Default.new
  client.read_timeout = 240 # instead of the default 60
  Capybara::Selenium::Driver.new(app,
                                 browser: :chrome,
                                 http_client: client,
                                 args: args)
end

Capybara.register_driver :headless_chrome do |app|
  profile = Selenium::WebDriver::Chrome::Profile.new
  client = Selenium::WebDriver::Remote::Http::Default.new
  client.read_timeout = 240 # instead of the default 60
  Capybara::Selenium::Driver.new(app, browser: :chrome,
                                 profile: profile,
                                 http_client: client,
                                 args: %w[ headless
                                           disable-gpu
                                           mute-audio
                                           --no-sandbox
                                           disable-extensions
                                           disable-password-generation
                                           disable-password-manager-reauthentication
                                           disable-save-password-bubble
                                           window-size=1440,900)])
end

Capybara.register_driver :chrome_mobile do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_emulation(device_metrics: { width: 360,
                                          height: 640,
                                          touch: true },
                        user_agent: 'Mozilla/5.0 (Linux; Android 5.0; SM-G900P Build/LRX21T) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.149 Mobile Safari/537.36')
  client = Selenium::WebDriver::Remote::Http::Default.new
  client.read_timeout = 240 # instead of the default 60
  Capybara::Selenium::Driver.new(app,
                                 browser: :chrome,
                                 options: options,
                                 http_client: client,
                                 args: %w[--start-maximized])
end

Selenium::WebDriver::Chrome::Service.driver_path = File.join(Dir.pwd, 'chromedriver.exe')


Capybara.javascript_driver = :selenium

Capybara.configure do |config|
  config.default_max_wait_time = 20 # seconds
  config.default_driver        = :selenium
  config.javascript_driver = :selenium
  config.run_server = false
  config.default_selector = :css
  config.ignore_hidden_elements = false
  config.exact = true
end

server_name = ENV['SERVER']

http = 'https'
host = 'dearmetea.com.tr'
stage_port = '8090'


Capybara.app_host = if server_name == 'stage'
                      "#{http}://#{host}:#{stage_port}"
                    else
                      "#{http}://#{host}"
                    end




#Capybara.run_server = false
Capybara.default_selector = :css
#Capybara.default_max_wait_time = 20 # default wait time for ajax
Capybara.ignore_hidden_elements = false
Capybara.exact = true

World(Capybara::DSL)
