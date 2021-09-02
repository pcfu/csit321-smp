module ModelConfigSpecHelpers
  def create_completed_and_requested_trainings(config, stocks, total, num_complete)
    total.times do |i|
      if i < num_complete
        create(:completed_training, model_config: config, stock: stocks[i])
      else
        create(:model_training, model_config: config, stock: stocks[i])
      end
    end
  end

  def create_completed_trainings(config, stocks, num)
    create_completed_and_requested_trainings(config, stocks, num, num)
  end

  def expected_train_percent(total, num_complete)
    (num_complete.to_f / total * 100).to_i
  end

  def expect_training_attrs(training_stock_ids, stage, rmse, error_message)
    ModelTraining.where(stock_id: training_stock_ids).each do |t|
      expect(t.stage.to_s).to eq(stage.to_s)
      expect(t.rmse).to eq(rmse)
      expect(t.error_message).to eq(error_message)
    end
  end
end
