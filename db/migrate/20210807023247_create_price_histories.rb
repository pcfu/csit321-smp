class CreatePriceHistories < ActiveRecord::Migration[6.1]
  def up
    create_table :price_histories do |t|
      t.references  :stock, null: false, foreign_key: true
      t.date        :date,  null: false
      t.decimal     :open
      t.decimal     :high
      t.decimal     :low
      t.decimal     :close
      t.integer     :volume
      t.decimal     :change
      t.decimal     :percent_change

      t.timestamps
    end

    add_index :price_histories, [:stock_id, :date], unique: true
    add_index :price_histories, :date
  end

  def down
    remove_index :price_histories, :date
    remove_index :price_histories, [:stock_id, :date]

    drop_table :price_histories
  end
end
