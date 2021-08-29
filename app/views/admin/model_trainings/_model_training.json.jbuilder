attrs = model_training.attribute_names - %w[created_at updated_at]

attrs.each do |attr|
  val = model_training[attr]
  json.set! attr, val.is_a?(BigDecimal) ? val.to_f : val
end
