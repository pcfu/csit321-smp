require 'rails_helper'

RSpec.describe "Thresholds", type: :request do
  describe "GET /update" do
    it "returns http success" do
      get "/threshold/update"
      expect(response).to have_http_status(:success)
    end
  end

end
