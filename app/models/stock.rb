class Stock < ApplicationRecord
  has_many :price_histories, dependent: :destroy
end
