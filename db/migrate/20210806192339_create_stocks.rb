class CreateStocks < ActiveRecord::Migration[6.1]
  def change
    create_table :stocks do |t|
      t.string  :symbol,      null: false, index: { unique: true }
      t.string  :name,        null: false, index: true
      t.string  :exchange,    null: false
      t.string  :stock_type,  null: false
      t.text    :description

      t.timestamps
    end
  end
end
