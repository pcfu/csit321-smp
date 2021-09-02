require 'rails_helper'

RSpec.describe ModelConfig, type: :model do
  subject(:config)  { full_trained }
  let(:full_trained) do
    use_db ? create(:full_trained, *traits) : build_stubbed(:full_trained, *traits)
  end
  let(:half_trained) do
    use_db ? create(:half_trained, *traits) : build_stubbed(:half_trained, *traits)
  end
  let(:untrained) do
    use_db ? create(:untrained, *traits) : build_stubbed(:untrained, *traits)
  end
  let(:traits)      { [] }
  let(:use_db)      { false }

  it { is_expected.to be_valid }

  describe "#name" do
    let(:use_db) { true }

    it "is required" do
      blank_strings.each do |name|
        config.name = name
        config.valid?
        expect(config.errors[:name]).to include("can't be blank")
      end
    end

    it "is case-insensitive unique" do
      config.name = half_trained.name.upcase
      config.valid?
      expect(config.errors[:name]).to include("has already been taken")
    end
  end

  describe "#params" do
    it "is required" do
      blank_strings.each do |params|
        config.params = params
        config.valid?
        expect(config.errors[:params]).to include("can't be blank")
      end
    end

    context "when content is not json" do
      let(:traits) { [:params_invalid_json] }

      it "is invalid" do
        config.valid?
        expect(config.errors[:params]).to include("is not a valid json string")
      end
    end

    context "when content is a string" do
      let(:traits) { [:params_string] }

      it "is invalid" do
        config.valid?
        expect(config.errors[:params]).to include("is not a valid json string")
      end
    end

    context "when content is an integer" do
      let(:traits) { [:params_integer] }

      it "is invalid" do
        config.valid?
        expect(config.errors[:params]).to include("is not a valid json string")
      end
    end

    context "when content is an array" do
      let(:traits) { [:params_array] }

      it "is invalid" do
        config.valid?
        expect(config.errors[:params]).to include("is not a valid json string")
      end
    end

    context "when content is an empty hash" do
      let(:traits) { [:params_empty_hash] }

      it "is invalid" do
        config.valid?
        expect(config.errors[:params]).to include("is not a valid json string")
      end
    end
  end


  # describe "#train_percent" do
  #   it "is required" do
  #     full.train_percent = nil
  #     full.valid?
  #     expect(full.errors[:train_percent]).to include("can't be blank")
  #   end

  #   it "is at least 0" do
  #     full = build_stubbed(:model_config, :train_percent_under_0)
  #     full.valid?
  #     expect(full.errors[:train_percent]).to include("must be greater than or equal to 0")
  #   end

  #   it "is at most 100" do
  #     full = build_stubbed(:model_config, :train_percent_above_100)
  #     full.valid?
  #     expect(full.errors[:train_percent]).to include("must be less than or equal to 100")
  #   end
  # end


  # describe "#methods" do
  #   let(:num_stocks)        { 10 }
  #   let(:num_trainings)     { 9 }
  #   let(:num_done)          { rand(3..7) }
  #   let(:expected_percent)  { (num_done.to_f / num_stocks * 100).to_i }
  #   let(:stocks)            { create_list(:boilerplate_stock, num_stocks) }
  #   let(:stock)             { stocks.first }


  #   describe "set_train_percent" do
  #     it "returns itself" do
  #       expect(untrained.set_train_percent).to eq(untrained)
  #     end

  #     it "sets train_percent to ratio of done model_trainings / total stocks" do
  #       num_trainings.times do |i|
  #         refs = { model_config_id: untrained.id, stock_id: stocks[i].id }
  #         i < num_done ? create(:completed_training, refs) : create(:model_training, refs)
  #       end

  #       untrained.update(train_percent: 0)
  #       expect {
  #         untrained.set_train_percent
  #       }.to change { untrained.train_percent }.to expected_percent
  #     end

  #     it "does not update the model" do
  #       create(:completed_training, model_config_id: untrained.id, stock_id: stocks[0].id )
  #       untrained.update(train_percent: 0)
  #       expect(untrained.set_train_percent.saved_change_to_train_percent?).to be false
  #     end
  #   end


  #   describe "set_train_percent!" do
  #     it "updates the model" do
  #       create(:completed_training, model_config_id: untrained.id, stock_id: stocks[0].id )
  #       untrained.update(train_percent: 0)
  #       expect(untrained.set_train_percent!.saved_change_to_train_percent?).to be true
  #     end
  #   end


  #   describe "reset_trainings" do
  #     let(:date_s)    { Date.new(2020, 1, 1) }
  #     let(:date_e)    { Date.new(2021, 1, 1) }
  #     let(:stock_ids) { stocks[0...5].pluck :id }
  #     let(:refs)      { Hash[model_config_id: half.id, stock_id: stock.id] }

  #     it "sets train percent to 0" do
  #       expect {
  #         half.reset_trainings(date_s, date_e)
  #       }.to change { half.train_percent }.from(50).to(0)
  #     end

  #     it "creates model_trainings if they don't exist" do
  #       expect {
  #         half.reset_trainings(date_s, date_e, [stock.id])
  #       }.to change(ModelTraining, :count).by 1
  #     end

  #     it "does not create model_trainings if they exist" do
  #       create(:full_training, refs)
  #       expect {
  #         half.reset_trainings(date_s, date_e, [stock.id])
  #       }.to change(ModelTraining, :count).by 0
  #     end

  #     context "for specified stocks" do
  #       it "resets model_trainings to default states" do
  #         stocks.each do |stock|
  #           create(:full_training, model_config_id: half.id, stock_id: stock.id)
  #         end

  #         half.reset_trainings(date_s, date_e, stock_ids[0...5])
  #         ModelTraining.where(stock_id: stock_ids[0...5]).each do |trng|
  #           expect(trng.requested?).to be true
  #           expect(trng.rmse.nil?).to be true
  #           expect(trng.error_message.nil?).to be true
  #         end
  #       end
  #     end

  #     context "for stocks not in specified list" do
  #       it "does not reset model_training" do
  #         stocks.each do |stock|
  #           create(:full_training, model_config_id: half.id, stock_id: stock.id)
  #         end

  #         half.reset_trainings(date_s, date_e, stock_ids[0...5])
  #         done_attrs = attributes_for(:completed_training)

  #         ModelTraining.where.not(stock_id: stock_ids[0...5]).each do |trng|
  #           expect(trng.stage.to_s).to eq(done_attrs[:stage].to_s)
  #           expect(trng.rmse).to eq(done_attrs[:rmse])
  #           expect(trng.error_message).to eq(done_attrs[:error_message])
  #         end
  #       end
  #     end

  #     context "when stocks ids not specified" do
  #       it "resets model_trainings for all stocks" do
  #         Stock.pluck(:id).each do |sid|
  #           create(:full_training, model_config_id: half.id, stock_id: sid)
  #         end

  #         half.reset_trainings(date_s, date_e)

  #         ModelTraining.all.each do |trng|
  #           expect(trng.requested?).to be true
  #           expect(trng.rmse.nil?).to be true
  #           expect(trng.error_message.nil?).to be true
  #         end
  #       end
  #     end
  #   end
  # end
end
