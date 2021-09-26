require 'rails_helper'

RSpec.describe "Login", type: :request do
  let(:valid_credentials)   { attributes_for(:user).slice(:email, :password) }
  let(:invalid_credentials) { Hash[email: 'unknown@email.com', password: 'incorrect'] }

  before { create :user }

  describe "GET /login" do
    context "when logged out" do
      it "returns http success" do
        get '/login'
        expect(response).to have_http_status(:success)
      end
    end

    context "when logged in" do
      before { login_user valid_credentials }

      it "returns redirect" do
        get '/login'
        expect(response).to be_redirect
      end
    end
  end

  describe "POST /login" do
    context "when valid credentials" do
      it "logs in user and returns redirect" do
        login_user valid_credentials
        expect(controller.logged_in?).to be true
        expect(response).to be_redirect
      end
    end

    context "when invalid credentials" do
      it "does not log in user and returns unauthorized" do
        login_user invalid_credentials
        expect(controller.logged_in?).to be false
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /logout" do
    before { login_user valid_credentials }

    it "logs out user and returns redirect" do
      post '/logout'
      expect(controller.logged_in?).to be false
      expect(response).to be_redirect
    end
  end
end
