class CreatePricePredicts < ActiveRecord::Migration[6.1]
  def change
    create_table :price_predicts do |t|
      t.references :stock, null: false, foreign_key: true
      t.date :entry_date
      t.date :nd_date
      t.decimal :nd_max_price
      t.decimal :nd_exp_price
      t.decimal :nd_min_price
      t.date :st_date
      t.decimal :st_max_price
      t.decimal :st_exp_price
      t.decimal :st_min_price
      t.date :mt_date
      t.decimal :mt_max_price
      t.decimal :mt_exp_price
      t.decimal :mt_min_price
      t.date :lt_date
      t.decimal :lt_max_price
      t.decimal :lt_exp_price
      t.decimal :lt_min_price

      t.timestamps
    end
  end
end
