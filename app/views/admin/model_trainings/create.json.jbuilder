json.status @response[:status]
json.message @response[:message]
json.results do
  json.array! @response[:results] do |result|
    result.each do |key, val|
      json.set! key, val
    end
  end
end
