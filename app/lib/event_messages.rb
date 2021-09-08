class EventMessages
  def self.model_config_training_progress(config)
    ts = format_time(config.updated_at)
    training_progress_message(config.name, config.train_percent, ts)
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

    def self.format_time(ts)
      ts.strftime("%Y-%m-%d %H:%M:%S.%3N")
    end
end
