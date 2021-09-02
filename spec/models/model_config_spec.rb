require 'rails_helper'
require './spec/support/spec_helpers/model_config_spec_helpers'

RSpec.configure do |config|
  config.include ModelConfigSpecHelpers, :group => :methods
end


RSpec.describe ModelConfig, type: :model do
  subject(:config)  { full_trained }
  let(:full_trained) do
    use_db ? create(:full_trained, *traits) : build_stubbed(:full_trained, *traits)
  end
  let(:half_trained) do
    use_db ? create(:half_trained, *traits) : build_stubbed(:half_trained, *traits)
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

  describe "#train_percent" do
    it "is required" do
      config.train_percent = nil
      config.valid?
      expect(config.errors[:train_percent]).to include("can't be blank")
    end

    context "when less than 0" do
      let(:traits) { [:train_percent_under_0]}

      it "is invalid" do
        config.valid?
        expect(config.errors[:train_percent]).to include("must be greater than or equal to 0")
      end
    end

    context "when more than 100" do
      let(:traits) { [:train_percent_above_100] }

      it "is invalid" do
        config.valid?
        expect(config.errors[:train_percent]).to include("must be less than or equal to 100")
      end
    end
  end

  describe "#methods", :group => :methods do
    let(:training)      { create(:completed_training, model_config: config, stock: stock) }
    let(:stocks)        { create_list(:boilerplate_stock, num_stocks) }
    let(:stock)         { create :stock }
    let(:num_stocks)    { 10 }
    let(:num_trainings) { 9 }
    let(:num_done)      { rand(3..7) }
    let(:use_db)        { true }

    describe "set_train_percent" do
      it "returns the model" do
        expect(config.set_train_percent).to eq(config)
      end

      it "does not update the model" do
        config.reload
        expect(config.set_train_percent.saved_change_to_train_percent?).to be false
      end

      it "sets train_percent to ratio of completed model_trainings / total stocks" do
        create_completed_and_requested_trainings(config, stocks, num_stocks, num_done)
        config.update(train_percent: 0)
        expect {
          config.set_train_percent
        }.to change { config.train_percent }.to expected_train_percent(num_stocks, num_done)
      end
    end

    describe "set_train_percent!" do
      it "updates the model" do
        config.reload
        expect(config.set_train_percent!.saved_change_to_train_percent?).to be true
      end
    end

    describe "reset_trainings" do
      let(:date_s)    { Date.new(2020, 1, 1) }
      let(:date_e)    { Date.new(2021, 1, 1) }

      it "sets train percent to 0" do
        expect {
          config.reset_trainings(date_s, date_e)
        }.to change { config.train_percent }.from(100).to(0)
      end

      it "creates model_trainings if they don't exist" do
        expect {
          config.reset_trainings(date_s, date_e, [stock.id])
        }.to change(ModelTraining, :count).by 1
      end

      it "does not create model_trainings if they exist" do
        config.update(model_trainings: [training])
        expect {
          config.reset_trainings(date_s, date_e, [stock.id])
        }.to change(ModelTraining, :count).by 0
      end

      context "for specified stocks" do
        let(:reset_stock_ids) { stocks[0...5].pluck(:id) }

        it "resets model_trainings to default states" do
          create_completed_trainings(config, stocks, stocks.count)
          config.reset_trainings(date_s, date_e, reset_stock_ids)
          expect_training_attrs(reset_stock_ids, :requested, nil, nil)
        end
      end

      context "for stocks not in specified list" do
        let(:reset_stock_ids) { stocks[0...5].pluck(:id) }
        let(:completed_stock_ids) { stocks[5...-1].pluck(:id) }

        it "does not reset model_training" do
          create_completed_trainings(config, stocks, stocks.count)
          config.reset_trainings(date_s, date_e, reset_stock_ids)
          attrs = attributes_for(:completed_training)
          expect_training_attrs(completed_stock_ids, attrs[:stage], attrs[:rmse], nil)
        end
      end

      context "when stocks ids not specified" do
        it "resets model_trainings for all stocks" do
          create_completed_trainings(config, stocks, stocks.count)
          config.reset_trainings(date_s, date_e)
          expect_training_attrs(Stock.pluck(:id), :requested, nil, nil)
        end
      end
    end
  end
end
