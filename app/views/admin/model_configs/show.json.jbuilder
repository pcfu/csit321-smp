json.status 'ok'
json.model_config do
  json.extract! @config, :id, :name, :train_percent
  json.params @config.parse_params
end
