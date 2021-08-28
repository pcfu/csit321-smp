require 'rails_helper'

RSpec.describe ModelTraining, type: :model do
  subject(:training) do
    build(:model_training, model_config_id: config.id, stock_id: google.id)
  end
  let(:ctrl_training) do
    create(:full_training, model_config_id: config.id, stock_id: facebook.id)
  end
  let(:config)    { create :model_config }
  let(:google)    { create :google }
  let(:facebook)  { create :facebook }

  it { is_expected.to be_valid }

  it "is unique per model config and stock" do
    training.stock_id = ctrl_training.stock_id
    training.valid?
    expect(training.errors[:stock_id]).to include("has already been taken")
  end

  describe "#date_start" do
    it "is required" do
      training.date_start = nil
      training.valid?
      expect(training.errors[:date_start]).to include("can't be blank")
    end
  end

  describe "#date_end" do
    it "is required" do
      training.date_end = nil
      training.valid?
      expect(training.errors[:date_end]).to include("can't be blank")
    end

    it "is after or equal to date_start" do
      training.date_end = training.date_start.advance(days: -1)
      training.valid?
      expect(training.errors[:date_end]).to include("must be after or equal to date_start")
    end
  end

  describe "#stage" do
    it "is required" do
      training.stage = nil
      training.valid?
      expect(training.errors[:stage]).to include("can't be blank")
    end

    it "accepts only enum values" do
      %w[requested enqueued training done error].each do |trait|
        training = build_stubbed(
          :model_training, trait,
          model_config_id: config.id,
          stock_id: google.id
        )
        expect(training).to be_valid
      end

      expect {
        training.stage = 'unknown'
      }.to raise_error(ArgumentError).with_message(/is not a valid stage/)
    end

    it "defaults to requested on initialization" do
      expect(ModelTraining.new.requested?).to be true
    end
  end

  describe "#rmse" do
    context "when present" do
      it "is greater than or equal to 0" do
        training.rmse = attributes_for(:model_training, :rmse_negative)[:rmse]
        training.valid?
        expect(training.errors[:rmse]).to include("must be greater than or equal to 0")
      end
    end

    context "when done" do
      it "is required" do
        training.stage = :done
        training.valid?
        expect(training.errors[:rmse]).to include("can't be blank")
      end
    end
  end

  describe "#error_message" do
    context "when error" do
      it "is required" do
        training = build_stubbed(
          :model_training, :error_with_no_message,
          model_config_id: config.id,
          stock_id: google.id,
        )
        training.valid?
        expect(training.errors[:error_message]).to include("can't be blank")
      end
    end
  end

  describe "#associations" do
    it "is destroyed when associated model_config is destroyed" do
      training.save
      config.destroy
      expect(ModelTraining.where(id: training.id)).to_not exist
    end

    it "is destroyed when associated stock is destroyed" do
      training.save
      google.destroy
      expect(ModelTraining.where(id: training.id)).to_not exist
    end
  end

  describe "#methods" do
    describe "#reset" do
      it "sets stage to requested" do
        expect(ctrl_training.reset.requested?).to be true
      end

      it "sets rmse to nil" do
        expect(ctrl_training.reset.rmse.nil?).to be true
      end

      it "sets error_message to nil" do
        expect(ctrl_training.reset.error_message.nil?).to be true
      end
    end
  end

  describe "#callbacks" do
    describe "after update" do
      let(:num_stocks)    { 10 }
      let(:num_trainings) { 9 }
      let(:num_done)      { rand(3..7) }
      subject(:config)    { create :model_config }

      it "updates model_config's train_percent when done" do
        num_stocks.times do |i|
          stock = create :boilerplate_stock
          next if i >= num_trainings

          create(:model_training, :training, model_config_id: config.id, stock_id: stock.id)
        end

        config.model_trainings.each_with_index do |training, idx|
          training.update(stage: :done, rmse: 1.0) if idx < num_done
        end

        expected = (num_done.to_f / num_stocks * 100).to_i
        expect(config.reload.train_percent).to eq(expected)
      end
    end
  end
end
