class AddColumnsToThreshold < ActiveRecord::Migration[6.1]
  def change
    add_column :thresholds, :buythreshold, :decimal
    add_column :thresholds, :sellthreshold, :decimal
  end
end
