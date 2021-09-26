require 'rails_helper'

RSpec.describe "UserRegistration", type: :system do
  let(:form) { build :registration_form }

  describe "page display" do
    before { visit '/register' }

    it "has correct title" do
      expect(page).to have_title('EZML | Registration', exact: true)
    end

    it "has correct form elements", js: true do
      within '#user-form' do
        expect(page).to have_css('.form-title', text: form[:title])
        form[:fields].each {|field| expect_field_with_label *field.values}
        expect(page).to have_button form[:submit]
        expect(page).to have_link(form[:have_account], href: '/login')
      end
    end
  end
end
