require 'rails_helper'

RSpec.describe PriceHistory, type: :model do
  let(:neg)       { -0.001 }
  let(:stock)     { create :stock }
  let(:ctrl_hist) { create(:ctrl_history, :stock_id => stock.id) }
  subject(:hist)  { build_stubbed(:price_history, :stock_id => stock.id) }

  it { is_expected.to be_valid }

  describe "#date" do
    it "is required" do
      hist.date = nil
      hist.valid?
      expect(hist.errors[:date]).to include("can't be blank")
    end

    it "is unique per stock" do
      hist.date = ctrl_hist.date
      hist.valid?
      expect(hist.errors[:date]).to include("has already been taken")
    end
  end

  describe "#open" do
    it "is required" do
      hist.open = nil
      hist.valid?
      expect(hist.errors[:open]).to include("can't be blank")
    end

    it "is greater than or equal to 0" do
      hist.open = neg
      hist.valid?
      expect(hist.errors[:open]).to include("must be greater than or equal to 0")
    end
  end

  describe "#high" do
    it "is required" do
      hist.high = nil
      hist.valid?
      expect(hist.errors[:high]).to include("can't be blank")
    end

    it "is greater than or equal to 0" do
      hist.high = neg
      hist.valid?
      expect(hist.errors[:high]).to include("must be greater than or equal to 0")
    end
  end

  describe "#low" do
    it "is required" do
      hist.low = nil
      hist.valid?
      expect(hist.errors[:low]).to include("can't be blank")
    end

    it "is greater than or equal to 0" do
      hist.low = neg
      hist.valid?
      expect(hist.errors[:low]).to include("must be greater than or equal to 0")
    end
  end

  describe "#close" do
    it "is required" do
      hist.low = nil
      hist.valid?
      expect(hist.errors[:low]).to include("can't be blank")
    end

    it "is greater than or equal to 0" do
      hist.close = neg
      hist.valid?
      expect(hist.errors[:close]).to include("must be greater than or equal to 0")
    end
  end

  describe "#volume" do
    it "is required" do
      hist.volume = nil
      hist.valid?
      expect(hist.errors[:volume]).to include("can't be blank")
    end

    it "is greater than or equal to 0" do
      hist.volume = neg
      hist.valid?
      expect(hist.errors[:volume]).to include("must be greater than or equal to 0")
    end
  end

  describe "#change" do
    it "is required" do
      hist.change = nil
      hist.valid?
      expect(hist.errors[:change]).to include("can't be blank")
    end
  end

  describe "#percent_change" do
    it "is required" do
      hist.percent_change = nil
      hist.valid?
      expect(hist.errors[:percent_change]).to include("can't be blank")
    end
  end

  describe "#associations" do
    it "is destroyed when associated stock is destroyed" do
      hist = create(:price_history, :stock_id => stock.id)
      stock.destroy
      expect(PriceHistory.where(:id => hist.id)).to_not exist
    end
  end
end
