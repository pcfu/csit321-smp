attrs = @tis.first.attribute_names - %w[created_at updated_at]

json.status 'ok'
json.technical_indicators do
  json.array! @tis do |tis|
    attrs.each do |attr|
      val = tis[attr]
      json.set! attr, val.is_a?(BigDecimal) ? val.to_f : val
    end
  end
end
