module Admin
  class PrototypeController < ApplicationController
    def index
      @config = ModelConfig.find(1)
      @predictions = PricePrediction.order(entry_date: :desc).limit(5)
    end


    private

      def prediction_values
        %w[ entry_date nd_date nd_max_price nd_exp_price nd_min_price
            st_date st_max_price st_exp_price st_min_price ]
      end
  end
end
