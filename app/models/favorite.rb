class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :stock
  has_one :threshold, dependent: :destroy
end
