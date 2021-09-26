module Admin
  class PrototypeController < ApplicationController
    before_action :redirect_if_not_admin

    def index
      @config = ModelConfig.find(1)
      @predictions = PricePrediction.order(entry_date: :desc).limit(5)
    end
  end
end
