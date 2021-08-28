class ModelConfig < ApplicationRecord
  has_many :model_trainings,  dependent: :destroy
  has_many :stocks,           through: :model_trainings

  auto_strip_attributes :name, :params

  validates :name,          presence: true, uniqueness: true
  validates :params,        presence: true,
                            json_string: {
                              allow_nil: true,
                              parses_to: [ Hash ],
                              parses_to_blank: false
                            }
  validates :train_percent, presence: true,
                            numericality: {
                              allow_nil: true,
                              greater_than_or_equal_to: 0,
                              less_than_or_equal_to: 100
                            }
end
