class ModelTraining < ApplicationRecord
  belongs_to :model_config
  belongs_to :stock
end
