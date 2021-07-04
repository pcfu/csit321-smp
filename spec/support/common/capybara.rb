RSpec.configure do |config|
  headless = ENV['HEADLESS'] == 'true'

  config.before(:each, type: :system) do
    driven_by :rack_test
  end
end
