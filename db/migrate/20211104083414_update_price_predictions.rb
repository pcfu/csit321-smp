class UpdatePricePredictions < ActiveRecord::Migration[6.1]
  def up
    remove_index :price_predictions, [:stock_id, :entry_date], if_exists: true

    change_table :price_predictions do |t|
      t.rename :entry_date, :reference_date
      t.remove :nd_date, :nd_max_price, :nd_exp_price, :nd_min_price,
               :st_max_price, :st_min_price,
               :mt_max_price, :mt_min_price,
               :lt_max_price, :lt_min_price
    end

    add_index :price_predictions, [:stock_id, :reference_date]
  end

  def down
    remove_index :price_predictions, [:stock_id, :reference_date], if_exists: true

    change_table :price_predictions do |t|
      t.rename  :reference_date, :entry_date
      t.date    :nd_date
      t.decimal :nd_max_price
      t.decimal :nd_exp_price
      t.decimal :nd_min_price
      t.decimal :st_max_price
      t.decimal :st_min_price
      t.decimal :mt_max_price
      t.decimal :mt_min_price
      t.decimal :lt_max_price
      t.decimal :lt_min_price
    end

    add_index :price_predictions, [:stock_id, :entry_date]
  end
end
