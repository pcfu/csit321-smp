class ModelParameter < ApplicationRecord
  validates_presence_of :name, :ml, :param_one, :param_two, :param_three,
                        :train_set, :start_date, :end_date
end
