class MlParam < ApplicationRecord
    validates :name, presence: true
    validates :ml, presence: true
    validates :paraOne, presence: true
    validates :paraTwo, presence: true
    validates :paraThree, presence: true
    validates :trainSet, presence: true
    validates :startDate, presence: true
    validates :endDate, presence: true
end
