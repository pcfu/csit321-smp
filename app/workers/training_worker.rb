class TrainingWorker
  include Sidekiq::Worker
  include BackendConnectionChecking
  include BackendJobsEnqueuing

  def perform(*args)
    return unless connection_up?

    ModelConfig.where(active: true).each_with_index do |mc, idx|
      schedule = mc.training_schedule
      next if Date.current < schedule.start_date

      schedule.update(start_date: Date.current.advance(days: schedule.frequency))
      puts "Enqueuing training for #{mc.name} (#{idx+1}/#{ModelConfig.count} models)"
      mc.reset_trainings

      training_data = mc.model_trainings.map do |t|
        { training_id: t.id, stock_id: t.stock_id, stock_symbol: t.stock.symbol }
      end

      model_data = {
        model_name: mc.name,
        model_class: mc.model_type,
        model_params: mc.parse_params
      }

      enqueue_training_jobs(training_data, model_data)
    end
  end
end
