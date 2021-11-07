namespace :db do
  desc "update stock price histories to most recent data"
  task :update_price_histories => :environment do
    Stock.pluck(:symbol).each_with_index do |sym, idx|
      puts "Enqueuing price retrieval for #{sym} (#{idx+1}/#{Stock.count} stocks)"
      Class.new.extend(BackendJobsEnqueuing).enqueue_price_retrieval_job sym
      sleep 1  # sending jobs too quickly results in ids getting mixed
    end
  end

  desc "update stock technical indicators to most recent data"
  task :update_technical_indicators => :environment do
    Stock.all.each_with_index do |s, idx|
      puts "Enqueuing TI calculation for #{s.symbol} (#{idx+1}/#{Stock.count} stocks)"
      Class.new.extend(BackendJobsEnqueuing).enqueue_tis_retrieval_job s.id
      sleep 1  # sending jobs too quickly results in ids getting mixed
    end
  end
end
