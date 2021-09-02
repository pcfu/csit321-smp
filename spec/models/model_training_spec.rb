require 'rails_helper'

RSpec.describe ModelTraining, type: :model do
  subject           { training }
  let(:training)    { build_stubbed(:model_training, *traits, assocs) }
  let(:trng_in_db)  { create(:model_training, *traits, assocs) }
  let(:config)      { use_db ? create(:model_config) : build_stubbed(:model_config) }
  let(:google)      { use_db ? create(:google) : build_stubbed(:google) }
  let(:assocs)      { Hash[model_config: config, stock: google] }
  let(:traits)      { [] }
  let(:use_db)      { false }

  it { is_expected.to be_valid }

  describe "#date_start" do
    it "is required" do
      training.date_start = nil
      training.valid?
      expect(training.errors[:date_start]).to include("can't be blank")
    end
  end

  describe "#date_end" do
    let(:traits) { [:date_end_before_date_start] }

    it "is required" do
      training.date_end = nil
      training.valid?
      expect(training.errors[:date_end]).to include("can't be blank")
    end

    it "is after or equal to date_start" do
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

    context "when not an enum value" do
      let(:traits) { :invalid_stage }

      it "raises an argument error" do
        expect { training }.to raise_error(ArgumentError).with_message(/is not a valid stage/)
      end
    end

    it "defaults to requested on initialization" do
      expect(ModelTraining.new.requested?).to be true
    end
  end

  describe "#rmse" do
    context "when done" do
      let(:traits) { [:rmse_nil] }

      it "is required" do
        training.valid?
        expect(training.errors[:rmse]).to include("can't be blank")
      end
    end

    context "when present" do
      let(:traits) { [:rmse_negative] }

      it "is greater than or equal to 0" do
        training.valid?
        expect(training.errors[:rmse]).to include("must be greater than or equal to 0")
      end
    end
  end

  describe "#error_message" do
    context "when error" do
      let(:traits) { [:error_with_no_message] }

      it "is required" do
        training.valid?
        expect(training.errors[:error_message]).to include("can't be blank")
      end
    end
  end

  describe "#associations" do
    let(:use_db) { true }

    it "is unique per model config and stock" do
      training.stock_id = trng_in_db.stock_id
      training.valid?
      expect(training.errors[:stock_id]).to include("has already been taken")
    end

    it "is destroyed when associated model_config is destroyed" do
      expect { config.destroy }.to change {
        ModelTraining.where(id: trng_in_db.id).count
      }.from(1).to(0)
    end

    it "is destroyed when associated stock is destroyed" do
      expect { google.destroy }.to change {
        ModelTraining.where(id: trng_in_db.id).count
      }.from(1).to(0)
    end
  end

  describe "#methods" do
    let(:traits) { [:done] }

    describe "#reset" do
      it "returns itself" do
        expect(training.reset).to eq(training)
      end

      it "sets stage to requested" do
        expect { training.reset }.to change { training.requested? }.to true
      end

      it "sets rmse to nil" do
        expect { training.reset }.to change { training.rmse }.to nil
      end

      context "when error" do
        let(:traits) { [:error] }

        it "sets error_message to nil" do
          expect { training.reset }.to change { training.error_message }.to nil
        end
      end

      it "does not update the model" do
        expect(training.reset.saved_change_to_updated_at?).to be false
      end
    end

    describe "#reset!" do
      let(:use_db) { true }

      it "updates the model" do
        expect(trng_in_db.reset!.saved_change_to_updated_at?).to be true
      end
    end
  end

  describe "#callbacks" do
    let(:use_db) { true }

    describe "on general updates" do
      let(:traits) { [:done] }

      context "when stage not changed" do
        it "does not fire callbacks" do
          expect(trng_in_db).to_not receive(:update_model_config_train_percent)
          trng_in_db.update(date_start: '2030-01-01', date_end: '2031-01-01', rmse: 2.0)
        end
      end
    end

    describe "on updating stage" do
      context "when stage changed from error to others" do
        let(:traits) { [:error] }

        it "sets error_message to nil" do
          expect {
            trng_in_db.enqueued!
          }.to change { trng_in_db.error_message.nil? }.from(false).to(true)
        end
      end

      context "when stage changed from done to others" do
        let(:traits) { [:done] }

        it "sets rmse to nil" do
          expect {
            trng_in_db.requested!
          }.to change { trng_in_db.rmse.nil? }.from(false).to(true)
        end

        it "updates model_config's train_percent" do
          expect {
            trng_in_db.requested!
          }.to change { config.train_percent }.from(100).to(0)
        end
      end

      context "when stage changed from others to done" do
        let(:traits) { [:training] }
        before { config.update(train_percent: 0) }

        it "updates model_config's train_percent" do
          expect {
            trng_in_db.update(stage: :done, rmse: 1.0)
          }.to change { config.train_percent }.from(0).to(100)
        end
      end

      context "when stage changed from others to others" do
        let(:traits) { [:enqueued] }

        it "does not update model_config's train_percent" do
          expect {
            trng_in_db.training!
          }.to_not change { config.train_percent }
        end
      end
    end
  end
end
