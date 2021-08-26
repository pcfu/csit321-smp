class Headline < ApplicationRecord
  belongs_to :stock

  auto_strip_attributes :title

  validates_presence_of :date, :title
end
