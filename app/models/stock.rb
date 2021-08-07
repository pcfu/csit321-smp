class Stock < ApplicationRecord
  has_many :price_histories, dependent: :destroy

  auto_strip_attributes :symbol, :name, :exchange, :stock_type, :description

  validates :symbol,      presence: true, uniqueness: true
  validates :name,        presence: true
  validates :exchange,    presence: true
  validates :stock_type,  presence: true

  before_validation :upcase_symbol


  private

    def upcase_symbol
      self.symbol.upcase! if symbol.present?
    end
end
