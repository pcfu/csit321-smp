require 'rails_helper'

RSpec.describe "UserRegistration", type: :system do
  let(:form)          { build :registration_form }
  let(:valid_input)   { attributes_for(:user).except(:role) }
  let(:invalid_input) { attributes_for(:invalid_user).except(:role) }

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


  context "when invalid input", js: true do
    before do |example|
      visit '/register'
      invalid_input.each {|key, val| fill_in "user_#{key}", with: val }
      find('input[type="submit"]').click unless example.metadata[:skip_submit]
    end

    it "does not create a user account", :skip_submit do
      expect { find('input[type="submit"]').click }.to_not change(User, :count)
    end

    it "displays error messages for invalid fields" do
      invalid_input.keys.each {|key| expect_field_with_error("user_#{key}")}
    end

    it "clears field errors on value change" do
      invalid_input.keys.each do |key|
        refill_field "user_#{key}", text: valid_input[key]
        expect_field_with_no_error "user_#{key}"
      end
    end

    it "preloads first_name, last_name, and email with previous input" do
      fields = [:first_name, :last_name, :email]
      invalid_input.slice(*fields).each do |key, val|
        expect(page).to have_field("user[#{key}]", with: val)
      end
    end

    it "does not preload password fields" do
      expect(page).to have_field("user[password]", with: '')
      expect(page).to have_field("user[password_confirmation]", with: '')
    end
  end
end
