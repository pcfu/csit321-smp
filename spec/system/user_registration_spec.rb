require 'rails_helper'

RSpec.describe "UserRegistration", type: :system do
  let(:form)        { build :registration_form }
  let(:valid_input) { attributes_for(:user).except(:role) }

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

  context "when valid input", js: true do
    before do
      visit '/register'
      valid_input.each {|key, val| fill_in "user_#{key}", with: val }
    end

    it "creates a new user account" do
      expect { find('input[type="submit"]').click }.to change(User, :count).by 1
    end

    it "redirects to homepage after registration" do
      expect {
        find('input[type="submit"]').click
      }.to change { current_path }.from('/register').to('/')
    end
  end
end
