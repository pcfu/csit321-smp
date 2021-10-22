module BackendJobsEnqueuing
  extend ActiveSupport::Concern

  TRAINING_ENDPOINT   = "ml/model_training"
  PREDICTION_ENDPOINT = "ml/prediction"
  PRICES_ENDPOINT     = "prices"
  TIS_ENDPOINT        = "tis"

  NO_STOCK_MSG        = { status: 'error', message: 'stock does not exist' }
  NO_UPDATE_MSG       = { status: 'ok', message: 'no update required' }

  private_constant :TRAINING_ENDPOINT, :PREDICTION_ENDPOINT,
                   :PRICES_ENDPOINT, :TIS_ENDPOINT,
                   :NO_STOCK_MSG, :NO_UPDATE_MSG


  def enqueue_price_retrieval_job(symbols)
    dates = symbols.map {|sym| PriceHistory.last_date_for_stock(symbol: sym)}
    earliest =  dates.sort.first
    today = Date.current
    return NO_UPDATE_MSG if earliest >= today

    data = { symbols: symbols, days: today.mjd - earliest.mjd }
    enqueue_job(PRICES_ENDPOINT, data)
  end

  def enqueue_tis_retrieval_job(stock_id)
    return NO_STOCK_MSG unless Stock.where(id: stock_id).exists?

    last_date = TechnicalIndicator.last_date_for_stock(stock_id: stock_id)
    from_date = last_date ? last_date.advance(days: 1) : Date.new
    prices = PriceHistory.where(stock_id: stock_id)
    n_last_data = prices.start(from_date).count
    return NO_UPDATE_MSG if n_last_data == 0

    data = { stock_id: stock_id, prices: prices.map(&:to_ohlcv), n_last_data: n_last_data }
    enqueue_job(TIS_ENDPOINT, data)
  end

  def enqueue_training_jobs(training_list, model_class, model_params)
    data = {
      training_list: training_list,
      model_class: model_class,
      model_params: model_params,
    }
    res = BackendClient.post(TRAINING_ENDPOINT, data)
    JSON.parse(res.body, symbolize_names: true)
  end

  def enqueue_prediction_job(training_id, stock_id)
    data = {
      training_id: training_id,
      stock_id: stock_id,
    }
    res = BackendClient.get(PREDICTION_ENDPOINT, data)
    JSON.parse(res.body, symbolize_names: true)
  end


  private

    def enqueue_job(endpoint, data)
      res = BackendClient.get(endpoint, data)
      JSON.parse(res.body, symbolize_names: true)
    end
end
