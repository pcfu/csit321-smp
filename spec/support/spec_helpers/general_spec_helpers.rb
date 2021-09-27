module GeneralSpecHelpers
  def login_user(credentials)
    post '/login', params: { session: credentials }
  end

  def gui_login_user(credentials, navigate_to_login: false)
    visit '/login' if navigate_to_login
    credentials.each {|key, val| fill_in "session_#{key}", with: val }
    find('input[type="submit"]').click
  end
end


RSpec.configure do |config|
  config.include GeneralSpecHelpers
end
