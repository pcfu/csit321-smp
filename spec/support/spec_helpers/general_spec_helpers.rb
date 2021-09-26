module GeneralSpecHelpers
  def login_user(credentials)
    post '/login', params: { session: credentials }
  end

  def expect_field_with_label(field, label)
    expect(page).to have_css("label[for=#{field}]", text: label)
    expect(page).to have_field field
  end
end

RSpec.configure do |config|
  config.include GeneralSpecHelpers
end
