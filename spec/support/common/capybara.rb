Capybara.register_driver :remote_chrome do |app|
  Capybara::Selenium::Driver.new(app,
    browser: :remote,
    url: "http://#{ENV['SELENIUM_HOST']}:9515",
    desired_capabilities: :chrome
  )
end

Capybara.register_driver :remote_chrome_headless do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w(headless disable-dev-shm-usage) }
  )

  Capybara::Selenium::Driver.new(app,
    browser: :remote,
    url: "http://#{ENV['SELENIUM_REMOTE_HOST']}:4444/wd/hub",
    desired_capabilities: capabilities
  )
end

RSpec.configure do |config|
  headless = ENV['HEADLESS'] == 'true'

  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    if headless
      driven_by :remote_chrome_headless
      Capybara.server_host = `/sbin/ip route|awk '/scope/ { print $9 }'`.strip
      Capybara.server_port = ENV.fetch('TEST_PORT', 3001)
      session_server       = Capybara.current_session.server
      Capybara.app_host    = "http://#{session_server.host}:#{session_server.port}"
    else
      driven_by :remote_chrome
      Capybara.server      = :puma, { Silent: true }
      Capybara.server_host = '0.0.0.0'
      Capybara.server_port = ENV.fetch('TEST_PORT', 3001)
      session_server       = Capybara.current_session.server
      Capybara.app_host    = "http://localhost:#{session_server.port}"
    end
  end
end
