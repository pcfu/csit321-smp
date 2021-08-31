require 'rails_helper'

RSpec.describe ModelTraining, type: :model do
  subject(:requested) do
    build(:model_training, model_config_id: config.id, stock_id: google.id)
  end

  let(:config)    { create :model_config }
  let(:google)    { create :google }
  let(:facebook)  { create :facebook }
  let(:refs)      { Hash[model_config_id: config.id, stock_id: facebook.id] }

  let(:enqueued)  { create(:minimum_training, :enqueued, refs) }
  let(:training)  { create(:minimum_training, :enqueued, refs) }
  let(:error)     { create(:minimum_training, :error, refs) }
  let(:completed) { create(:completed_training, refs) }

  let(:invalid) { build_stubbed(:minimum_training, refs.merge(stage: :test)) }


  it { is_expected.to be_valid }


  it "is unique per model config and stock" do
    requested.stock_id = enqueued.stock_id
    requested.valid?
    expect(requested.errors[:stock_id]).to include("has already been taken")
  end


  describe "#date_start" do
    it "is required" do
      requested.date_start = nil
      requested.valid?
      expect(requested.errors[:date_start]).to include("can't be blank")
    end
  end


  describe "#date_end" do
    it "is required" do
      requested.date_end = nil
      requested.valid?
      expect(requested.errors[:date_end]).to include("can't be blank")
    end

    it "is after or equal to date_start" do
      requested.date_end = requested.date_start.advance(days: -1)
      requested.valid?
      expect(requested.errors[:date_end]).to include("must be after or equal to date_start")
    end
  end


  describe "#stage" do
    it "is required" do
      requested.stage = nil
      requested.valid?
      expect(requested.errors[:stage]).to include("can't be blank")
    end

    it "accepts only enum values" do
      expect { invalid }.to raise_error(ArgumentError).with_message(/is not a valid stage/)
    end

    it "defaults to requested on initialization" do
      expect(ModelTraining.new.requested?).to be true
    end
  end


  describe "#rmse" do
    context "when present" do
      it "is greater than or equal to 0" do
        requested.rmse = attributes_for(:rmse_negative)[:rmse]
        requested.valid?
        expect(requested.errors[:rmse]).to include("must be greater than or equal to 0")
      end
    end

    context "when done" do
      it "is required" do
        requested.stage = :done
        requested.valid?
        expect(requested.errors[:rmse]).to include("can't be blank")
      end
    end
  end


  describe "#error_message" do
    context "when error" do
      it "is required" do
        expect {
          create :error_with_no_message
        }.to raise_error(ActiveRecord::RecordInvalid).with_message(/can't be blank/)
      end
    end
  end


  describe "#associations" do
    it "is destroyed when associated model_config is destroyed" do
      requested.save
      config.destroy
      expect(ModelTraining.where(id: requested.id)).to_not exist
    end

    it "is destroyed when associated stock is destroyed" do
      requested.save
      google.destroy
      expect(ModelTraining.where(id: requested.id)).to_not exist
    end
  end


  describe "#methods" do
    describe "#reset" do
      it "returns itself" do
        expect(completed.reset).to eq(completed)
      end

      it "sets stage to requested" do
        expect { completed.reset }.to change { completed.requested? }.to true
      end

      it "sets rmse to nil" do
        expect { completed.reset }.to change { completed.rmse }.to nil
      end

      it "sets error_message to nil" do
        expect { error.reset }.to change { error.error_message }.to nil
      end

      it "does not update the model" do
        expect(requested.reset.saved_change_to_updated_at?).to be false
      end
    end


    describe "#reset!" do
      it "updates the model" do
        expect(requested.reset!.saved_change_to_updated_at?).to be true
      end
    end
  end


  describe "#callbacks" do
    describe "on update" do
      context "when stage not changed" do
        it "does not fire callbacks" do
          expect(completed).to_not receive(:update_model_config_train_percent)
          completed.update(date_start: '2030-01-01', date_end: '2031-01-01', rmse: 2.0)
        end
      end
    end

    describe "on updating stage" do
      context "when stage changed from done to others" do
        it "updates model_config's train_percent" do
          expect {
            completed.update(stage: :requested)
            config.reload
          }.to change { config.train_percent }.from(100).to(0)
        end
      end

      context "when stage changed from others to done" do
        before { config.update(train_percent: 0) }

        it "updates model_config's train_percent" do
          expect {
            enqueued.update(stage: :done, rmse: 1.0)
            config.reload
          }.to change { config.train_percent }.from(0).to(100)
        end
      end

      context "when stage changed from others to others" do
        it "does not update model_config's train_percent" do
          expect {
            requested.update(stage: :training)
            config.reload
          }.to_not change { config.train_percent }
        end
      end
    end
  end
end
