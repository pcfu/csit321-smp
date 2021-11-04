class PricePrediction < ApplicationRecord
  PREFIX = %i(st mt lt)
  SUFFIX = %i(date exp_price)
  ATTRS = [:reference_date] + PREFIX.product(SUFFIX).map {|p, s| "#{p}_#{s}".to_sym}
  PRICES = ATTRS.select {|attr| attr.to_s.include? 'price'}
  private_constant :PREFIX, :SUFFIX, :PRICES

  belongs_to :stock

  after_create :broadcast_new_prediction

  validates_presence_of *ATTRS
  validates_numericality_of *PRICES, greater_than_or_equal_to: 0


  def to_chart_json
    attrs = attributes.symbolize_keys.slice(*ATTRS)
    json = attrs.each {|k, v| attrs[k] = v.to_f.round(3) if v.is_a? BigDecimal }

    ref_price = stock.price_histories.find_by(date: reference_date).close.to_f.round(3)
    json.merge({ reference_price: ref_price })
  end


  private

    def broadcast_new_prediction
      AdminChannel.broadcast EventMessages.price_prediction_creation(self)
    end
end
