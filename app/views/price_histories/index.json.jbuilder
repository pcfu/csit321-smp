attrs = @price_histories.first.attribute_names - %w[created_at updated_at]

json.status 'ok'
json.price_histories do
  json.array! @price_histories do |p_hist|
    attrs.each do |attr|
      val = p_hist[attr]
      json.set! attr, val.is_a?(BigDecimal) ? val.to_f : val
    end
  end
end
