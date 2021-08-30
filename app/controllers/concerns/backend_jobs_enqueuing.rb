module BackendJobsEnqueuing
  extend ActiveSupport::Concern

  TRAINING_ENDPOINT = "/ml/model_training"
  private_constant :TRAINING_ENDPOINT


  def enqueue_training_jobs(training_list, model_params, data_range)
    data = {
      training_list: training_list,
      model_params: model_params,
      data_range: data_range
    }
    res = BackendClient.post(TRAINING_ENDPOINT, data)
    JSON.parse(res.body, symbolize_names: true)
  end
end
