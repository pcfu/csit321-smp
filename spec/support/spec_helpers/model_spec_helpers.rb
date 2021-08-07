module ModelSpecHelpers
  def blank_strings(include_nil: true)
    blanks = [ '', '     ' ]
    blanks += [ nil ] if include_nil
    return blanks
  end
end

RSpec.configure do |config|
  config.include ModelSpecHelpers
end
