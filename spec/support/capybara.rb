# frozen_string_literal: true

Capybara.register_driver :remote_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('no-sandbox')
  options.add_argument('headless')
  options.add_argument('disable-gpu')
  options.add_argument('window-size=1680,1050')
  options.add_argument('--disable-dev-shm-usage') # メモリ不足対策
  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: ENV.fetch('SELENIUM_DRIVER_URL', 'http://selenium:4444/wd/hub'),
    capabilities: options
  )
end

Capybara.server_host = '0.0.0.0'
Capybara.server_port = ENV.fetch('CAPYBARA_PORT', 3002).to_i
Capybara.app_host = "http://#{Capybara.server_host}:#{Capybara.server_port}"
Capybara.javascript_driver = :remote_chrome
