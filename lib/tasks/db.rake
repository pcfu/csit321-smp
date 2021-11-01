namespace :db do
  desc "update stock price histories to most recent data"
  task :update_price_histories => :environment do
    Stock.pluck(:symbol).each do |sym|
      Class.new.extend(BackendJobsEnqueuing).enqueue_price_retrieval_job sym
      sleep 1  # sending jobs too quickly results in ids getting mixed
    end
  end

  desc "update stock technical indicators to most recent data"
  task :update_technical_indicators => :environment do
    Stock.pluck(:id).each do |id|
      Class.new.extend(BackendJobsEnqueuing).enqueue_tis_retrieval_job id
      sleep 1  # sending jobs too quickly results in ids getting mixed
    end
  end
end
