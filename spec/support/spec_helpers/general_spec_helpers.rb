module GeneralSpecHelpers
  def login_user(credentials)
    post '/login', params: { session: credentials }
  end

  def gui_login_user(credentials, navigate_to_login: false)
    visit '/login' if navigate_to_login
    credentials.each {|key, val| fill_in "session_#{key}", with: val }
    find('input[type="submit"]').click
  end

  def expect_field_with_label(field, label)
    expect(page).to have_css("label[for=#{field}]", text: label)
    expect(page).to have_field field
  end

  def expect_field_with_errors(field)
    js = "$('label[for=\"#{field}\"]').parent().siblings('.field-error-message')"
    element = page.evaluate_script js
    expect(element.present?).to be true

    js = "$('##{field}').parent('.field_with_errors')"
    element = page.evaluate_script js
    expect(element.present?).to be true
  end
end

RSpec.configure do |config|
  config.include GeneralSpecHelpers
end
