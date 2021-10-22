json.status 'ok'

json.sister_stocks do
  json.array! @sister_prices do |sis|
    json.symbol sis.first[0]

    json.price_histories do
      json.array! sis.first[1] do |prices|
        json.date   prices[:date]
        json.close  prices[:close].to_f
      end
    end
  end
end
