class PriceRetrievalWorker
  include Sidekiq::Worker
  include BackendConnectionChecking
  include BackendJobsEnqueuing

  def perform(*args)
    return unless connection_up?

    Stock.pluck(:symbol).each_with_index do |sym, idx|
      puts "Enqueuing price retrieval for #{sym} (#{idx+1}/#{Stock.count} stocks)"
      enqueue_price_retrieval_job sym
      sleep 1  # sending jobs too quickly results in ids getting mixed
    end
  end
end
