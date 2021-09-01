require 'rails_helper'

RSpec.describe PricePrediction, type: :model do
  subject                 { prediction }
  let(:prediction)        { build_stubbed(:price_prediction, *traits, stock: stock) }
  let(:prediction_in_db)  { create(:price_prediction, stock: stock) }
  let(:stock)             { use_db ? create(:stock) : build_stubbed(:stock) }
  let(:use_db)            { false }
  let(:traits)            { [] }
  let(:neg)               { -0.001 }

  it { is_expected.to be_valid }

  describe "#entry_date" do
    it "is required" do
      prediction.entry_date = nil
      prediction.valid?
      expect(prediction.errors[:entry_date]).to include("can't be blank")
    end
  end

  describe "#nd_date" do
    context "when no entry_date" do
      let(:traits) { [:entry_date_nil, :nd_date_nil] }

      it "is required" do
        prediction.valid?
        expect(prediction.errors[:nd_date]).to include("can't be blank")
      end
    end

    context "when blank and entry_date present" do
      let(:traits) { [:nd_date_nil] }

      it "is imputed to 1 day after entry date on validation" do
        date = prediction.entry_date.advance(days: 1)
        expect { prediction.valid? }.to change { prediction.nd_date }.from(nil).to(date)
      end
    end
  end

  describe "#nd_min_price" do
    it "is required" do
      prediction.nd_min_price = nil
      prediction.valid?
      expect(prediction.errors[:nd_min_price]).to include("can't be blank")
    end

    it "is greater than or equal to 0" do
      prediction.nd_min_price = neg
      prediction.valid?
      expect(prediction.errors[:nd_min_price]).to include("must be greater than or equal to 0")
    end
  end

  describe "#nd_exp_price" do
    it "is required" do
      prediction.nd_exp_price = nil
      prediction.valid?
      expect(prediction.errors[:nd_exp_price]).to include("can't be blank")
    end

    it "is greater than or equal to 0" do
      prediction.nd_exp_price = neg
      prediction.valid?
      expect(prediction.errors[:nd_exp_price]).to include("must be greater than or equal to 0")
    end
  end

  describe "#nd_max_price" do
    it "is required" do
      prediction.nd_max_price = nil
      prediction.valid?
      expect(prediction.errors[:nd_max_price]).to include("can't be blank")
    end

    it "is greater than or equal to 0" do
      prediction.nd_max_price = neg
      prediction.valid?
      expect(prediction.errors[:nd_max_price]).to include("must be greater than or equal to 0")
    end
  end

  describe "#st_date" do
    context "when no entry_date" do
      let(:traits) { [:entry_date_nil, :st_date_nil] }

      it "is required" do
        prediction.valid?
        expect(prediction.errors[:st_date]).to include("can't be blank")
      end
    end

    context "when blank and entry_date present" do
      let(:traits) { [:st_date_nil] }

      it "is imputed to #{PricePrediction::ST_DAYS} days after entry date on valiidation" do
        date = prediction.entry_date.advance(days: PricePrediction::ST_DAYS)
        expect { prediction.valid? }.to change { prediction.st_date }.from(nil).to(date)
      end
    end
  end

  describe "#st_min_price" do
    it "is required" do
      prediction.st_min_price = nil
      prediction.valid?
      expect(prediction.errors[:st_min_price]).to include("can't be blank")
    end

    it "is greater than or equal to 0" do
      prediction.st_min_price = neg
      prediction.valid?
      expect(prediction.errors[:st_min_price]).to include("must be greater than or equal to 0")
    end
  end

  describe "#st_exp_price" do
    it "is required" do
      prediction.st_exp_price = nil
      prediction.valid?
      expect(prediction.errors[:st_exp_price]).to include("can't be blank")
    end

    it "is greater than or equal to 0" do
      prediction.st_exp_price = neg
      prediction.valid?
      expect(prediction.errors[:st_exp_price]).to include("must be greater than or equal to 0")
    end
  end

  describe "#st_max_price" do
    it "is required" do
      prediction.st_max_price = nil
      prediction.valid?
      expect(prediction.errors[:st_max_price]).to include("can't be blank")
    end

    it "is greater than or equal to 0" do
      prediction.st_max_price = neg
      prediction.valid?
      expect(prediction.errors[:st_max_price]).to include("must be greater than or equal to 0")
    end
  end

  describe "#mt_date" do
    context "when no entry_date" do
      let(:traits) { [:entry_date_nil, :mt_date_nil] }

      it "is required" do
        prediction.valid?
        expect(prediction.errors[:mt_date]).to include("can't be blank")
      end
    end

    context "when blank and entry_date present" do
      let(:traits) { [:mt_date_nil] }

      it "is imputed to #{PricePrediction::MT_DAYS} days after entry date on validation" do
        date = prediction.entry_date.advance(days: PricePrediction::MT_DAYS)
        expect { prediction.valid? }.to change { prediction.mt_date }.from(nil).to(date)
      end
    end
  end

  describe "#mt_min_price" do
    it "is required" do
      prediction.mt_min_price = nil
      prediction.valid?
      expect(prediction.errors[:mt_min_price]).to include("can't be blank")
    end

    it "is greater than or equal to 0" do
      prediction.mt_min_price = neg
      prediction.valid?
      expect(prediction.errors[:mt_min_price]).to include("must be greater than or equal to 0")
    end
  end

  describe "#mt_exp_price" do
    it "is required" do
      prediction.mt_exp_price = nil
      prediction.valid?
      expect(prediction.errors[:mt_exp_price]).to include("can't be blank")
    end

    it "is greater than or equal to 0" do
      prediction.mt_exp_price = neg
      prediction.valid?
      expect(prediction.errors[:mt_exp_price]).to include("must be greater than or equal to 0")
    end
  end

  describe "#mt_max_price" do
    it "is required" do
      prediction.mt_max_price = nil
      prediction.valid?
      expect(prediction.errors[:mt_max_price]).to include("can't be blank")
    end

    it "is greater than or equal to 0" do
      prediction.mt_max_price = neg
      prediction.valid?
      expect(prediction.errors[:mt_max_price]).to include("must be greater than or equal to 0")
    end
  end

  describe "#lt_date" do
    context "when no entry_date" do
      let(:traits) { [:entry_date_nil, :lt_date_nil] }

      it "is required" do
        prediction.valid?
        expect(prediction.errors[:lt_date]).to include("can't be blank")
      end
    end

    context "when blank and entry_date present" do
      let(:traits) { [:lt_date_nil] }

      it "is imputed to #{PricePrediction::LT_DAYS} days after entry date on validation" do
        date = prediction.entry_date.advance(days: PricePrediction::LT_DAYS)
        expect { prediction.valid? }.to change { prediction.lt_date }.from(nil).to(date)
      end
    end
  end

  describe "#lt_min_price" do
    it "is required" do
      prediction.lt_min_price = nil
      prediction.valid?
      expect(prediction.errors[:lt_min_price]).to include("can't be blank")
    end

    it "is greater than or equal to 0" do
      prediction.lt_min_price = neg
      prediction.valid?
      expect(prediction.errors[:lt_min_price]).to include("must be greater than or equal to 0")
    end
  end

  describe "#lt_exp_price" do
    it "is required" do
      prediction.lt_exp_price = nil
      prediction.valid?
      expect(prediction.errors[:lt_exp_price]).to include("can't be blank")
    end

    it "is greater than or equal to 0" do
      prediction.lt_exp_price = neg
      prediction.valid?
      expect(prediction.errors[:lt_exp_price]).to include("must be greater than or equal to 0")
    end
  end

  describe "#lt_max_price" do
    it "is required" do
      prediction.lt_max_price = nil
      prediction.valid?
      expect(prediction.errors[:lt_max_price]).to include("can't be blank")
    end

    it "is greater than or equal to 0" do
      prediction.lt_max_price = neg
      prediction.valid?
      expect(prediction.errors[:lt_max_price]).to include("must be greater than or equal to 0")
    end
  end

  describe "#associations" do
    let(:use_db)  { true }

    it "is destroyed when associated stock is destroyed" do
      expect { stock.destroy }.to change {
        PricePrediction.where(:id => prediction_in_db.id).count
      }.from(1).to(0)
    end
  end
end
