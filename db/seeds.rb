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



puts "=== INSERTING PRICE PREDICTION ==="

filepath = "#{DATA_DIR}/price_predict_list.json"
price_data = JSON.parse(File.read(filepath))
price_data.each {|price_predict| PricePredict.create(price_predict)}