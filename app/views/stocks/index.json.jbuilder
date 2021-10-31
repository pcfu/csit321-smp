json.array! @stocks do |s|
  json.id       s.id
  json.symbol   s.symbol
  json.name     s.name
  json.exchange s.exchange
  json.industry s.industry.titleize
end
