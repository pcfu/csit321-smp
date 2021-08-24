class AlterPricePredicts < ActiveRecord::Migration[6.1]
  PREFIX = %i(nd st mt lt)
  SUFFIX = %i(date max_price exp_price min_price)
  COLUMNS = [:entry_date] + PREFIX.product(SUFFIX).map {|p, s| "#{p}_#{s}".to_sym}

  def up
    rename_table :price_predicts, :price_predictions

    COLUMNS.each do |col|
      change_column_null :price_predictions, col, false
    end

    add_index :price_predictions, [:stock_id, :entry_date]
  end

  def down
    remove_index :price_predictions, [:stock_id, :entry_date]

    COLUMNS.each do |col|
      change_column_null :price_predictions, col, true
    end

    rename_table :price_predictions, :price_predicts
  end
end
