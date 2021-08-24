require 'rails_helper'

RSpec.describe PricePrediction, type: :model do
  let(:neg)   { -0.001 }
  let(:stock) { create :stock }
  subject(:prediction) { build_stubbed(:price_prediction, :stock_id => stock.id) }

  it { is_expected.to be_valid }

  describe "#entry_date" do
    it "is required" do
      prediction.entry_date = nil
      prediction.valid?
      expect(prediction.errors[:entry_date]).to include("can't be blank")
    end
  end

  describe "#nd_date" do
    before { prediction.nd_date = nil }

    it "is required" do
      prediction.entry_date = nil
      prediction.valid?
      expect(prediction.errors[:nd_date]).to include("can't be blank")
    end

    context "when blank and entry_date present" do
      it "is imputed to 1 day after entry date" do
        expect(prediction).to be_valid
        expect(prediction.nd_date).to eq prediction.entry_date.advance(days: 1)
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
    before { prediction.st_date = nil }

    it "is required" do
      prediction.entry_date = nil
      prediction.valid?
      expect(prediction.errors[:st_date]).to include("can't be blank")
    end

    context "when blank and entry_date present" do
      it "is imputed to #{PricePrediction::ST_DAYS} days after entry date" do
        expect(prediction).to be_valid
        imputed_date = prediction.entry_date.advance(days: PricePrediction::ST_DAYS)
        expect(prediction.st_date).to eq imputed_date
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
    before { prediction.mt_date = nil }

    it "is required" do
      prediction.entry_date = nil
      prediction.valid?
      expect(prediction.errors[:mt_date]).to include("can't be blank")
    end

    context "when blank and entry_date present" do
      it "is imputed to #{PricePrediction::MT_DAYS} days after entry date" do
        expect(prediction).to be_valid
        imputed_date = prediction.entry_date.advance(days: PricePrediction::MT_DAYS)
        expect(prediction.mt_date).to eq imputed_date
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
    before { prediction.lt_date = nil }

    it "is required" do
      prediction.entry_date = nil
      prediction.valid?
      expect(prediction.errors[:lt_date]).to include("can't be blank")
    end

    context "when blank and entry_date present" do
      it "is imputed to #{PricePrediction::LT_DAYS} days after entry date" do
        expect(prediction).to be_valid
        imputed_date = prediction.entry_date.advance(days: PricePrediction::LT_DAYS)
        expect(prediction.lt_date).to eq imputed_date
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
    it "is destroyed when associated stock is destroyed" do
      prediction = create(:price_prediction, :stock_id => stock.id)
      stock.destroy
      expect(PricePrediction.where(:id => prediction.id)).to_not exist
    end
  end
end
