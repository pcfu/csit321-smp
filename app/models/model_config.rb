class ModelConfig < ApplicationRecord
  has_many :model_trainings,  dependent: :destroy
  has_many :stocks,           through: :model_trainings

  auto_strip_attributes :name, :params

  validates :name,          presence: true, uniqueness: { case_sensitive: false }
  validates :params,        presence: true,
                            json_string: { allow_nil: true,
                                           parses_to: [ Hash ],
                                           parses_to_blank: false }
  validates :train_percent, presence: true,
                            numericality: { allow_nil: true,
                                            greater_than_or_equal_to: 0,
                                            less_than_or_equal_to: 100 }

  def set_train_percent
    num_done = model_trainings.done.count
    total = model_trainings.count
    update(train_percent: (num_done.to_f / total * 100).to_i)
    return self
  end
end
