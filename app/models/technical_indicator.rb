class TechnicalIndicator < ApplicationRecord
  extend LastDateForStockSearchable

  belongs_to :stock

  scope :start, ->(date) { where('date >= ?', date || '-infinity') }
  scope :end,   ->(date) { where('date <= ?', date || 'infinity') }

  validates_presence_of :date
  validates :date, uniqueness: { scope: :stock_id }
end
