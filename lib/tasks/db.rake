namespace :db do
  desc "update stock price histories to most recent data"
  task :update_price_histories => :environment do
    dates = Stock.all.map {|s| s.price_histories.order(date: :desc).first.date}
    earliest = dates[0]
    today = Date.current
    return if earliest >= today

    query = {
      symbols: Stock.pluck(:symbol),
      days: today.mjd - earliest.mjd
    }
    BackendClient.get('/prices', query)
  end
end
