class EventMessages
  def self.model_config_training_progress(config)
    ts = format_time(config.updated_at)
    training_progress_message(config.name, config.train_percent, ts)
  end

  def self.price_prediction_creation(prediction)
    symbol = prediction.stock.symbol
    prices = prediction.to_chart_json
    message = "New prediction for #{symbol} stock"
    new_prediction_message(symbol, prices, message)
  end


  private

    def self.training_progress_message(name, percent, timestamp)
      msg = training_progress_base_message(percent, timestamp)
      if percent == 100
        msg[:body][:message] = "#{name} is 100% trained (#{Stock.count} stocks)"
      end
      msg
    end

    def self.training_progress_base_message(percent, timestamp)
      {
        subject: 'model_config',
        context: percent == 100 ? 'success' : 'primary',
        body: { train_percent: percent, updated_at: timestamp }
      }
    end

    def self.new_prediction_message(symbol, prices, message)
      {
        subject: 'price_prediction',
        context: 'success',
        body: { symbol: symbol, message: message }.merge(prices)
      }
    end

    def self.format_time(ts)
      ts.strftime("%Y-%m-%d %H:%M:%S.%3N")
    end
end
