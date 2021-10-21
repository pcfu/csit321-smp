# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

DATA_DIR = "#{Rails.root}/db/seed_data"

puts "=== INSERTING STOCKS ==="

filepath = "#{DATA_DIR}/stocks_list.json"
stocks = JSON.parse(File.read(filepath))
stocks.each {|stock| Stock.create(stock)}


puts "=== INSERTING PRICE HISTORIES ==="

keys = %w[date open high low close volume change]
filenames = "#{DATA_DIR}/price_histories/*.json"

Dir.glob(filenames) do |filepath|
  prices = JSON.parse(File.read(filepath))
  stock = Stock.find_by(:symbol => prices.first['symbol'])

  prices.each_with_index do |price, idx|
    print "\rInserting price for #{stock.symbol} (#{idx + 1} of #{prices.count})"
    params = price.slice(*keys).merge({ percent_change: price['changePercent'] })
    stock.price_histories.create! params
  end
  puts
end


puts "=== INSERTING PRICE PREDICTIONS ==="

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


puts "=== INSERTING RECOMMENDATIONS ==="

filepath = "#{DATA_DIR}/recommendations_list.json"
recommendations_data = JSON.parse(File.read(filepath))
recommendations_data.each do |symbol, recommendations|
  stock = Stock.find_by(:symbol => symbol)

  recommendations.each_with_index do |recomm, idx|
    print "\rInserting recommendations for #{symbol} (#{idx + 1} of #{recommendations.count})"
    stock.recommendations.create recomm
  end
  puts
end


puts "=== INSERTING MODEL CONFIGS ==="

params = {
  model_class: 'PricePredictionLSTM',
  init_options: {
    layers: [
      {
        type: 'lstm',
        settings: {
          units: 50,
          return_sequences: true,
          input_shape: [100, 1]
        }
      },
      {
        type: 'lstm',
        settings: {
          units: 50,
          return_sequences: true
        }
      },
      {
        type: 'lstm',
        settings: {
          units: 50
        }
      },
      {
        type: 'dense',
        settings: {
          units: 1
        }
      }
    ],
    compile: {
      loss: 'mean_squared_error',
      optimizer: 'adam'
    }
  },
  training_options: {
    epochs: 100,
    batch_size: 64
  },
  data_fields: ['close']
}

ModelConfig.create(
  name: "basic LSTM configuration",
  params: params.to_json,
  train_percent: 0
)
