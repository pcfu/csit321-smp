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

end
