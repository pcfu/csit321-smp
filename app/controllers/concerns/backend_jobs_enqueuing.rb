module BackendJobsEnqueuing
  extend ActiveSupport::Concern

  TRAINING_ENDPOINT   = "/ml/model_training"
  PREDICTION_ENDPOINT = "ml/prediction"
  private_constant :TRAINING_ENDPOINT, :PREDICTION_ENDPOINT


  def enqueue_training_jobs(training_list, model_params, data_range)
    data = {
      training_list: training_list,
      model_params: model_params,
      data_range: data_range
    }
    res = BackendClient.post(TRAINING_ENDPOINT, data)
    JSON.parse(res.body, symbolize_names: true)
  end

  def enqueue_prediction_job(training_id, stock_id, data_range)
    data = {
      training_id: training_id,
      stock_id: stock_id,
      data_range: data_range
    }
    res = BackendClient.get(PREDICTION_ENDPOINT, data)
    JSON.parse(res.body, symbolize_names: true)
  end
end
