class CreateStocks < ActiveRecord::Migration[6.1]
  def change
    create_table :stocks do |t|
      t.string :symbol
      t.string :name
      t.string :exchange
      t.string :stock_type
      t.text :description

      t.timestamps
    end
  end
end
