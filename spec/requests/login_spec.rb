require 'rails_helper'

RSpec.describe "Login", type: :request do
  let(:valid_credentials)   { attributes_for(:user).slice(:email, :password) }
  let(:invalid_credentials) { Hash[email: 'unknown@email.com', password: 'incorrect'] }

  describe "GET /login" do
    it "returns http success" do
      get '/login'
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /login" do
    before { create :user }

    context "when valid credentials" do
      # it logs in user and returns redirect

      it "returns redirect" do
        post '/login', params: { session: valid_credentials }
        expect(response).to be_redirect
      end
    end

    context "when invalid credentials" do
      it "returns unauthorized" do
        post '/login', params: { session: invalid_credentials }
        # expect not logged in
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
