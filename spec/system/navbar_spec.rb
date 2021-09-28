require 'rails_helper'

RSpec.describe "Navbar", type: :system do
  let(:credentials) { attributes_for(:user).slice(:email, :password) }

  describe "display" do
    before { visit '/' }

    it "has site brand" do
      expect(page).to have_css('.navbar-brand[href="/"]', text: 'EZML')
    end

    it "has a link to stocks page" do
      expect(page).to have_css('.navbar .nav-link[href="/stocks"]', text: 'Stocks')
    end

    it "has a link to login page" do
      expect(page).to have_css('.navbar .nav-link[href="/login"]', text: 'Login')
    end
  end


  context "when logged in" do
    let!(:user) { create :user }
    before { gui_login_user credentials, navigate_to_login: true }

    it "has an avatar with user initials" do
      expect(page).to have_css('#avatar')
      expect(page).to have_css('#user-initials', text: user.initials)
    end

    it "opens user control panel on avatar click", :js do
      find('#avatar').click
      expect(page).to have_no_css('.control-panel.d-none')

      within('.control-panel') do
        expect(page).to have_css('#username', text: user.full_name)
        expect(page).to have_css('#user-email', text: user.email)
        expect(page).to have_button("Log out")
      end
    end
  end
end
