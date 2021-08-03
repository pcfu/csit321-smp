require 'rails_helper'

RSpec.describe "StockData", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/stock_data/index"
      expect(response).to have_http_status(:success)
    end
  end

end
