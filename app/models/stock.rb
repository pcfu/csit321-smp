class Stock < ApplicationRecord
  has_many :price_histories,      dependent: :destroy
  has_many :technical_indicators, dependent: :destroy
  has_many :price_predictions,    dependent: :destroy
  has_many :recommendations,      dependent: :destroy
  has_many :model_trainings,      dependent: :destroy
  has_many :model_configs,        through: :model_trainings

  enum industry: { technology: 'technology', energy: 'energy', healthcare: 'healthcare' }

  auto_strip_attributes :symbol, :name, :exchange
  before_validation :upcase_symbol

  validates :symbol,    presence: true, uniqueness: true
  validates :name,      presence: true
  validates :exchange,  presence: true
  validates :industry,  presence: true


  private

    def upcase_symbol
      self.symbol.upcase! if symbol.present?
    end
end
