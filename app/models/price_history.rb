class PriceHistory < ApplicationRecord
  extend LastDateForStockSearchable

  belongs_to :stock

  scope :start, ->(date) { where('date >= ?', date || '-infinity') }
  scope :end,   ->(date) { where('date <= ?', date || 'infinity') }

  validates_presence_of :date, :open, :high, :low, :close,
                        :volume, :change, :percent_change
  validates_numericality_of :open, :high, :low, :close, :volume,
                            greater_than_or_equal_to: 0
  validates :date, uniqueness: { scope: :stock_id }
end
