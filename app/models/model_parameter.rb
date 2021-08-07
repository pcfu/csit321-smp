class ModelParameter < ApplicationRecord
  DATA_SETS = [
    "Tesla", "Apple", "Microsoft", "Alphabet",
    "General Motors", "Samsung", "Temasek Holdings"
  ]

  validates_presence_of :name, :ml, :param_one, :param_two, :param_three,
                        :train_set, :start_date, :end_date
end
