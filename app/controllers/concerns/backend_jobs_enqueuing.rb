module BackendJobsEnqueuing
  extend ActiveSupport::Concern

  TRAINING_ENDPOINT       = "ml/model_training"
  PREDICTION_ENDPOINT     = "ml/prediction"
  RECOMMENDATION_ENDPOINT = "ml/recommendation"
  PRICES_ENDPOINT         = "prices"
  TIS_ENDPOINT            = "tis"

  NO_STOCK_MSG        = { status: 'error', message: 'stock does not exist' }
  NO_UPDATE_MSG       = { status: 'ok', message: 'no update required' }

  private_constant :TRAINING_ENDPOINT, :PREDICTION_ENDPOINT, :RECOMMENDATION_ENDPOINT,
                   :PRICES_ENDPOINT, :TIS_ENDPOINT, :NO_STOCK_MSG, :NO_UPDATE_MSG


  def enqueue_price_retrieval_job(symbol)
    return NO_STOCK_MSG unless Stock.where(symbol: symbol).exists?

    today = Date.current
    last_date = PriceHistory.last_date_for_stock(symbol: symbol)
    n_last_data = last_date ? today.mjd - last_date.mjd : today.mjd - Date.new.mjd
    return NO_UPDATE_MSG if n_last_data <= 0

    data = { symbol: symbol, days: n_last_data }
    enqueue_job(:get, PRICES_ENDPOINT, data )
  end

  def enqueue_tis_retrieval_job(stock_id)
    return NO_STOCK_MSG unless Stock.where(id: stock_id).exists?

    last_date = TechnicalIndicator.last_date_for_stock(stock_id: stock_id)
    from_date = last_date ? last_date.advance(days: 1) : Date.new
    prices = PriceHistory.where(stock_id: stock_id).order(date: :asc)
    n_last_data = prices.start(from_date).count
    return NO_UPDATE_MSG if n_last_data == 0

    data = { stock_id: stock_id, prices: prices.map(&:to_ohlcv), n_last_data: n_last_data }
    enqueue_job(:get, TIS_ENDPOINT, data)
  end

  def enqueue_training_jobs(training_list, model)
    data = { training_list: training_list, model: model }
    enqueue_job(:post, TRAINING_ENDPOINT, data)
  end

  def enqueue_prediction_job(training_id, stock_id)
    data = { training_id: training_id, stock_id: stock_id }
    enqueue_job(:get, PREDICTION_ENDPOINT, data)
  end

  def enqueue_recommendation_jobs(stocks)
    data = { stocks: stocks }
    enqueue_job(:get, RECOMMENDATION_ENDPOINT, data)
  end


  private

    def enqueue_job(method, endpoint, data)
      res = BackendClient.send(method, endpoint, data)
      JSON.parse(res.body, symbolize_names: true)
    end
end
