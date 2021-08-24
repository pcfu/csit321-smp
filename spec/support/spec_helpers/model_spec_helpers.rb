module ModelSpecHelpers
  def blank_strings
    [ nil, '', '     ' ]
  end
end

RSpec.configure do |config|
  config.include ModelSpecHelpers
end
