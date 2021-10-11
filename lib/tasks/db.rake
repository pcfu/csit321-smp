namespace :db do
  desc "update stock price histories to most recent data"
  task :update_price_histories => :environment do
    syms = Stock.pluck :symbol
    Class.new.extend(BackendJobsEnqueuing).enqueue_price_retrieval_job syms
  end

  desc "update stock technical indicators to most recent data"
  task :update_technical_indicators => :environment do
    Stock.pluck(:id).each do |id|
      Class.new.extend(BackendJobsEnqueuing).enqueue_tis_retrieval_job id
    end
  end
end
