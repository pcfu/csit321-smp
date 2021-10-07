class CreateTechnicalIndicators < ActiveRecord::Migration[6.1]
  def up
    create_table :technical_indicators do |t|
      t.references  :stock, null: false, foreign_key: true
      t.date        :date,  null: false
      t.decimal     :sma

      t.timestamps
    end

    add_index :technical_indicators, [:stock_id, :date], unique: true
    add_index :technical_indicators, :date
  end

  def down
    remove_index :technical_indicators, :date
    remove_index :technical_indicators, [:stock_id, :date]

    drop_table :technical_indicators
  end
end
