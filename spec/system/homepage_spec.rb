require 'rails_helper'

RSpec.describe "Homepage", type: :system do
  before { visit '/' }

  describe "page is displayed correctly", js: true do
    it "has a h1 heading" do
      h1_text = 'Welcome to the Stock Market Prediction App'
      expect(page).to have_css('h1', text: h1_text)
    end

    it "has a h2 heading" do
      h2_text = 'CSIT321 Final Year Project'
      expect(page).to have_css('h2', text: h2_text)
    end

    it "has all group member names" do
      member_selector = '.members-container > span'
      members = [ 'Jonathan', 'Ling Yi', 'PC', 'Joey', 'Muru' ]
      members.each {|m| expect(page).to have_css(member_selector, text: m)}
    end
  end
end
