class CreatePriceHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :price_histories do |t|
      t.integer :stock_id
      t.date :date
      t.decimal :open
      t.decimal :high
      t.decimal :low
      t.decimal :close
      t.integer :volume
      t.decimal :change
      t.decimal :percent_change

      t.timestamps
    end
  end
end
