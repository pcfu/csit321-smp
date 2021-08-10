# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

filepath = "#{Rails.root}/db/stocks_list.json"
stocks = JSON.parse(File.read(filepath))
stocks.each {|stock| Stock.create(stock)}

#Price History Dummy Data
filepath = "#{Rails.root}/db/pricehistory_list.json"
pricehistories = JSON.parse(File.read(filepath))
pricehistories.each {|pricehistory| PriceHistory.create(pricehistory)}
