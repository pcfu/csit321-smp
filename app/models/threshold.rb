class Threshold < ApplicationRecord

  belongs_to :favorite


  validates :sellthreshold, 
            :numericality => {:allow_nil => true, :greater_than => :buythreshold}, 
            :on => :update 

  
end
