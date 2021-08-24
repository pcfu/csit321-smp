class PricePrediction < ApplicationRecord
  ST_DAYS = 14
  MT_DAYS = 90
  LT_DAYS = 365

  PREFIX = %i(nd st mt lt)
  SUFFIX = %i(date max_price exp_price min_price)
  ATTRS = [:entry_date] + PREFIX.product(SUFFIX).map {|p, s| "#{p}_#{s}".to_sym}
  PRICES = ATTRS.select {|attr| attr.to_s.include? 'price'}
  private_constant :PREFIX, :SUFFIX, :ATTRS, :PRICES

  belongs_to :stock

  before_validation :impute_dates

  validates_presence_of *ATTRS
  validates_numericality_of *PRICES, greater_than_or_equal_to: 0


  private

    def impute_dates
      if entry_date.present?
        self.nd_date = entry_date.advance(days: 1) if nd_date.nil?
        self.st_date = entry_date.advance(days: ST_DAYS) if st_date.nil?
        self.mt_date = entry_date.advance(days: MT_DAYS) if mt_date.nil?
        self.lt_date = entry_date.advance(days: LT_DAYS) if lt_date.nil?
      end
    end
end
