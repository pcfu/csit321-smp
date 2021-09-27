require 'rails_helper'

RSpec.describe "UserLogin", type: :system do
  let(:form)              { build :login_form }
  let(:valid_credentials) { attributes_for(:user).slice(:email, :password) }

  describe "page display" do
    before { visit '/login' }

    it "has correct title" do
      expect(page).to have_title('EZML | Login', exact: true)
    end

    it "has correct form elements", js: true do
      within '#login-form' do
        expect(page).to have_css('.form-title', text: form[:title])
        form[:fields].each {|field| expect_field_with_label *field.values}
        expect(page).to have_button form[:submit]
        expect(page).to have_css('.form-text > span', text: form[:new_to_ezml])
        expect(page).to have_link(form[:register], href: '/register')
      end
    end
  end
end
