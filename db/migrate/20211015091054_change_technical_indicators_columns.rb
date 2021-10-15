class ChangeTechnicalIndicatorsColumns < ActiveRecord::Migration[6.1]
  def change
    change_table :technical_indicators do |t|
      t.rename  :sma, :sma_5
      t.decimal :sma_8
      t.decimal :sma_10
      t.decimal :wma_5
      t.decimal :wma_8
      t.decimal :wma_10
      t.decimal :macd
      t.decimal :cci
      t.decimal :stoch_k
      t.decimal :stoch_d
      t.decimal :williams
      t.decimal :rsi
      t.decimal :roc
      t.decimal :ad
      t.decimal :atr
    end
  end
end
