module SystemSpecHelpers
  def refill_field(field, text: '')
    fill_in field, with: text
    page.evaluate_script "$('##{field}').trigger('blur')"
  end

  def expect_field_with_label(field, label)
    expect(page).to have_css("label[for=#{field}]", text: label)
    expect(page).to have_field field
  end

  def expect_field_with_error(field)
    js = "$('label[for=\"#{field}\"]').parent().siblings('.field-error-message')"
    element = page.evaluate_script js
    expect(element.present?).to be true

    expect(page).to have_css(".field_with_errors > ##{field}")
  end

  def expect_field_with_no_error(field)
    js = "$('label[for=\"#{field}\"]').parent().siblings('.field-error-message')"
    element = page.evaluate_script js
    expect(element.present?).to be false

    expect(page).to have_no_css(".field_with_errors > ##{field}")
  end
end


RSpec.configure do |config|
  config.include SystemSpecHelpers
end
