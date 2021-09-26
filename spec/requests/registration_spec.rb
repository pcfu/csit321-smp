require 'rails_helper'

RSpec.describe "Registration", type: :request do
  let(:valid_input)   { attributes_for(:user) }
  let(:invalid_input) { attributes_for(:user, :pw_too_short) }
  let(:credentials)   { valid_input.slice(:email, :password) }

  describe "GET /register" do
    context "when logged out" do
      it "returns http success" do
        get '/register'
        expect(response).to have_http_status(:success)
      end
    end

    context "when logged in" do
      before do
        create :user
        login_user credentials
      end

      it "returns redirect" do
        get '/register'
        expect(response).to be_redirect
      end
    end
  end

  describe "POST /register" do
    context "when valid input" do
      it "logs in user and returns redirect" do
        post '/register', params: { user: valid_input }
        expect(controller.logged_in?).to be true
        expect(response).to be_redirect
      end
    end

    context "when invalid input" do
      it "it returns conflict" do
        post '/register', params: { user: invalid_input }
        expect(controller.logged_in?).to be false
        expect(response).to have_http_status(:conflict)
      end
    end
  end
end
