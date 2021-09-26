module GeneralSpecHelpers
  def login_user(credentials)
    post '/login', params: { session: credentials }
  end
end

RSpec.configure do |config|
  config.include GeneralSpecHelpers
end
