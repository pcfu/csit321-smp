require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /register" do
    it "returns http success" do
      get '/register'
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /register" do
    context "when valid registration" do
      # it "logs in user and returns redirect" do
      #   post '/register', params: { user: attributes_for(:user) }
      #   expect(controller.logged_in?).to be true
      #   expect(response).to be_redirect
      # end

      it "returns http success" do
        post '/register', params: { user: attributes_for(:user) }
        expect(response).to be_redirect
      end
    end

    context "when invalid registration" do
      it "it returns conflict" do
        post '/register', params: { user: attributes_for(:user, :pw_too_short) }
        #expect(controller.logged_in?).to be false
        expect(response).to have_http_status(:conflict)
      end
    end
  end
end
