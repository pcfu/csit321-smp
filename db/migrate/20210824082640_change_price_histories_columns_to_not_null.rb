class ChangePriceHistoriesColumnsToNotNull < ActiveRecord::Migration[6.1]
  def change
    change_column_null :price_histories, :open,           false
    change_column_null :price_histories, :high,           false
    change_column_null :price_histories, :low,            false
    change_column_null :price_histories, :close,          false
    change_column_null :price_histories, :volume,         false
    change_column_null :price_histories, :change,         false
    change_column_null :price_histories, :percent_change, false
  end
end
