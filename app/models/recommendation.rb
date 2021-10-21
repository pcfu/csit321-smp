class Recommendation < ApplicationRecord
  private

    def impute_dates
      if entry_date.present?
        self.nd_date = entry_date.advance(days: 1) if nd_date.nil?
        self.st_date = entry_date.advance(days: ST_DAYS) if st_date.nil?
      end
    end

    # def broadcast_new_prediction
    #   AdminChannel.broadcast EventMessages.price_prediction_creation(self)
    # end
end
