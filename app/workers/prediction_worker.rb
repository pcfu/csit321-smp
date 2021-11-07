class PredictionWorker
  include Sidekiq::Worker
  include BackendConnectionChecking
  include BackendJobsEnqueuing

  def perform(*args)
    return unless connection_up?

    predict_prices
    predict_recommendations
  end

  private

    def predict_prices
      config = ModelConfig.where(model_type: :lstm, active: true).first
      puts "Predicting prices with #{config.name}"

      enqueue_prediction_job build_data(config)
    end

    def predict_recommendations
      config = ModelConfig.where(model_type: [:svm, :rf], active: true).first
      puts "Predicting recommendations with #{config.name}"

      enqueue_recommendation_jobs build_data(config)
    end

    def build_data(config)
      config.model_trainings.done.map do |t|
        path = "trained_models/#{config.name.upcase}_#{t.stock.symbol}"
        last_prc = t.stock.price_histories.order(date: :desc).first
        { id: t.stock_id, model_path: path, latest_date: last_prc.date.strftime('%Y-%m-%d') }
      end
    end
end
