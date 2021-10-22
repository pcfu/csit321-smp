class Recommendation < ApplicationRecord

  ST_DAYS = 14
  MT_DAYS = 90

  belongs_to :stock
  before_validation :impute_dates

  private
    def impute_dates
      if entry_date.present?
        self.nd_date = entry_date.advance(days: 1) if nd_date.nil?
        self.st_date = entry_date.advance(days: ST_DAYS) if st_date.nil?
        self.mt_date = entry_date.advance(days: MT_DAYS) if mt_date.nil?
      end
    end

    # def broadcast_new_prediction
    #   AdminChannel.broadcast EventMessages.price_prediction_creation(self)
    # end
end
