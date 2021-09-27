require 'rails_helper'

RSpec.describe "UserLogin", type: :system do
  let(:form)              { build :login_form }
  let(:valid_credentials) { attributes_for(:user).slice(:email, :password) }
  let(:wrong_email)       { valid_credentials.merge(email: 'unknown') }
  let(:wrong_password)    { valid_credentials.merge(password: 'incorrect') }

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

  context "when valid credentials", js: true do
    let!(:user) { create :user }

    before { visit '/login' }

    it "logs in user" do
      gui_login_user valid_credentials
      expect(page).to have_css('#user-initials', text: user.initials)
    end

    it "redirects to homepage" do
      expect {
        gui_login_user valid_credentials
      }.to change { current_path }.from('/login').to('/')
    end
  end

  context "when account does not exist", js: true do
    before do
      create :user
      gui_login_user(wrong_email, navigate_to_login: true)
    end

    it "does not log in" do
      expect(page).to have_css('.nav-link[href="/login"]', text: 'Login')
    end

    it "displays an error message on email field" do
      expect_field_with_error('session_email')
      expect(page).to have_css('.field-error-message', text: form[:errors][:email])
    end

    it "clears email field errors on value change" do
      refill_field 'session_email', text: valid_credentials[:email]
      expect_field_with_no_error('session_email')
    end
  end

  context "when incorrect password", js: true do
    before do
      create :user
      gui_login_user(wrong_password, navigate_to_login: true)
    end

    it "does not log in" do
      expect(page).to have_css('.nav-link[href="/login"]', text: 'Login')
    end

    it "displays an error message on password field" do
      expect_field_with_error('session_password')
      expect(page).to have_css('.field-error-message', text: form[:errors][:password])
    end

    it "clears password field errors on value change" do
      refill_field 'session_password', text: valid_credentials[:password]
      expect_field_with_no_error('session_password')
    end
  end

  describe "logging out", js: true do
    let!(:user) { create :user }

    before do
      gui_login_user(valid_credentials, navigate_to_login: true)
      find('#avatar').click
      find('#logout-btn').click
    end

    it "logs user out and redirects to homepage" do
      expect(page).to have_no_css '#user-initials'
      expect(page).to have_current_path '/'
    end
  end
end
