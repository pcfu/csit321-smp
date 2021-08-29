json.status 'ok'
json.result do
  json.partial! 'admin/model_trainings/model_training', model_training: @model_training
end
