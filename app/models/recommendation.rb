class Recommendation < ApplicationRecord
  belongs_to :stock

  enum verdict: { buy: 'buy', hold: 'hold', sell: 'sell' }

  validates_presence_of :prediction_date, :verdict
end
