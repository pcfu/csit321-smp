require 'rails_helper'

RSpec.describe ModelTraining, type: :model do
  subject(:training) do
    build(:model_training, model_config_id: config.id, stock_id: google.id)
  end
  let(:ctrl_training) do
    create(:model_training, model_config_id: config.id, stock_id: facebook.id)
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

  describe "#job_id" do
    context "when enqueued stage or later" do
      it "is required" do
        %w[enqueued training done].each do |trait|
          training = build_stubbed(
            :model_training, trait,
            model_config_id: config.id,
            stock_id: google.id,
            job_id: nil
          )
          training.valid?
          expect(training.errors[:job_id]).to include("can't be blank")
        end
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
    it "is destroyed when associated model config is destroyed" do
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
end
