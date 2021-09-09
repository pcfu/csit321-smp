class PricePrediction < ApplicationRecord
  ST_DAYS = 14
  MT_DAYS = 90
  LT_DAYS = 365

  PREFIX = %i(nd st mt lt)
  SUFFIX = %i(date max_price exp_price min_price)
  ATTRS = [:entry_date] + PREFIX.product(SUFFIX).map {|p, s| "#{p}_#{s}".to_sym}
  PRICES = ATTRS.select {|attr| attr.to_s.include? 'price'}
  private_constant :PREFIX, :SUFFIX, :PRICES

  belongs_to :stock

  before_validation :impute_dates
  after_create      :broadcast_new_prediction

  validates_presence_of *ATTRS
  validates_numericality_of *PRICES, greater_than_or_equal_to: 0


  def to_chart_json
    attrs = attributes.symbolize_keys.slice(*ATTRS)
    json = attrs.each {|k, v| attrs[k] = v.to_f.round(3) if v.is_a? BigDecimal }
    json.merge({ nd_day: 1, st_day: ST_DAYS, mt_day: MT_DAYS, lt_day: LT_DAYS })
  end


  private

    def impute_dates
      if entry_date.present?
        self.nd_date = entry_date.advance(days: 1) if nd_date.nil?
        self.st_date = entry_date.advance(days: ST_DAYS) if st_date.nil?
        self.mt_date = entry_date.advance(days: MT_DAYS) if mt_date.nil?
        self.lt_date = entry_date.advance(days: LT_DAYS) if lt_date.nil?
      end
    end

    def broadcast_new_prediction
      AdminChannel.broadcast EventMessages.price_prediction_creation(self)
    end
end
