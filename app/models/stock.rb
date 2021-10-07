class Stock < ApplicationRecord
  has_many :price_histories,      dependent: :destroy
  has_many :technical_indicators, dependent: :destroy
  has_many :price_predictions,    dependent: :destroy
  has_many :headlines,            dependent: :destroy
  has_many :model_trainings,      dependent: :destroy
  has_many :model_configs,        through: :model_trainings

  auto_strip_attributes :symbol, :name, :exchange, :stock_type, :description
  before_validation :upcase_symbol

  validates :symbol,      presence: true, uniqueness: true
  validates :name,        presence: true
  validates :exchange,    presence: true
  validates :stock_type,  presence: true


  private

    def upcase_symbol
      self.symbol.upcase! if symbol.present?
    end
end
