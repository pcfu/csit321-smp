class EventMessages
  def self.model_config_training_progress(config)
    {
      subject: "model training progress",
      model_name: config.name,
      percent: config.train_percent
    }
  end

  def self.price_prediction_creation(prediction)
    symbol = prediction.stock.symbol
    prices = prediction.to_chart_json
    message = "New prediction for #{symbol} stock"
    new_prediction_message(symbol, prices, message)
  end


  private

    def self.new_prediction_message(symbol, prices, message)
      {
        subject: 'price_prediction',
        context: 'success',
        body: { symbol: symbol, message: message }.merge(prices)
      }
    end
end
