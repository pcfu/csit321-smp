# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

DATA_DIR = "#{Rails.root}/db/seed_data"


puts "=== INSERTING STOCKS ==="

filepath = "#{DATA_DIR}/stocks_list.json"
stocks = JSON.parse(File.read(filepath))
stocks.each {|stock| Stock.create(stock)}


puts "=== INSERTING PRICE HISTORIES ==="

filepath = "#{DATA_DIR}/price_histories_list.json"
price_data = JSON.parse(File.read(filepath))
price_data.each do |symbol, prices|
  stock = Stock.find_by(:symbol => symbol)

  prices.each_with_index do |prc, idx|
    print "\rInserting price for #{symbol} (#{idx + 1} of #{prices.count})"
    stock.price_histories.create prc
  end
  puts
end


puts "=== INSERTING PRICE PREDICTIONs ==="

filepath = "#{DATA_DIR}/price_predictions_list.json"
predictions_data = JSON.parse(File.read(filepath))
predictions_data.each do |symbol, predictions|
  stock = Stock.find_by(:symbol => symbol)

  predictions.each_with_index do |pred, idx|
    print "\rInserting prediction for #{symbol} (#{idx + 1} of #{predictions.count})"
    stock.price_predictions.create pred
  end
  puts
end


puts "=== INSERTING MODEL CONFIGS ==="

###
# Params based on the following python code in LSTM_Basic.ipynb
###

# model=Sequential()
# model.add(LSTM(50,return_sequences=True,input_shape=(100,1)))
# model.add(LSTM(50,return_sequences=True))
# model.add(LSTM(50))
# model.add(Dense(1))
# model.compile(loss='mean_squared_error',optimizer='adam')

params = {
  model: 'sequential',
  layers: [
    {
      type: 'lstm',
      nodes: 50,
      return_sequences: true,
      input_shape: [100, 1]
    },
    {
      type: 'lstm',
      nodes: 50,
      return_sequences: true
    },
    {
      type: 'lstm',
      nodes: 50
    },
    {
      type: 'dense',
      nodes: 1
    }
  ],
  compile: {
    loss: 'mean_squared_error',
    optimizer: 'adam'
  }
}

ModelConfig.create(
  name: "basic LSTM configuration",
  params: params.to_json,
  train_percent: 0
)
