class TiRetrievalWorker
  include Sidekiq::Worker
  include BackendConnectionChecking
  include BackendJobsEnqueuing

  def perform(*args)
    return unless connection_up?

    Stock.all.each_with_index do |s, idx|
      puts "Enqueuing TI calculation for #{s.symbol} (#{idx+1}/#{Stock.count} stocks)"
      enqueue_tis_retrieval_job s.id
      sleep 1  # sending jobs too quickly results in ids getting mixed
    end
  end
end
