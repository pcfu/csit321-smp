require 'rails_helper'

RSpec.describe "UserRegistration", type: :system do
  describe "page is displayed correctly" do
    before { visit '/register' }

    it "has correct title" do
      expect(page).to have_title('EZML | Registration', exact: true)
    end
  end
end
