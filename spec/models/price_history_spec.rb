require 'rails_helper'

RSpec.describe PriceHistory, type: :model do
  subject             { history }
  let(:history)       { build_stubbed(:price_history, stock: stock) }
  let(:history_in_db) { create(:ctrl_history, stock: stock) }
  let(:stock)         { use_db ? create(:stock) : build_stubbed(:stock) }
  let(:use_db)        { false }
  let(:neg)           { -0.001 }

  it { is_expected.to be_valid }

  describe "#date" do
    let(:use_db) { true }

    it "is required" do
      history.date = nil
      history.valid?
      expect(history.errors[:date]).to include("can't be blank")
    end

    it "is unique per stock" do
      history.date = history_in_db.date
      history.valid?
      expect(history.errors[:date]).to include("has already been taken")
    end
  end

  describe "#open" do
    it "is required" do
      history.open = nil
      history.valid?
      expect(history.errors[:open]).to include("can't be blank")
    end

    it "is greater than or equal to 0" do
      history.open = neg
      history.valid?
      expect(history.errors[:open]).to include("must be greater than or equal to 0")
    end
  end

  describe "#high" do
    it "is required" do
      history.high = nil
      history.valid?
      expect(history.errors[:high]).to include("can't be blank")
    end

    it "is greater than or equal to 0" do
      history.high = neg
      history.valid?
      expect(history.errors[:high]).to include("must be greater than or equal to 0")
    end
  end

  describe "#low" do
    it "is required" do
      history.low = nil
      history.valid?
      expect(history.errors[:low]).to include("can't be blank")
    end

    it "is greater than or equal to 0" do
      history.low = neg
      history.valid?
      expect(history.errors[:low]).to include("must be greater than or equal to 0")
    end
  end

  describe "#close" do
    it "is required" do
      history.low = nil
      history.valid?
      expect(history.errors[:low]).to include("can't be blank")
    end

    it "is greater than or equal to 0" do
      history.close = neg
      history.valid?
      expect(history.errors[:close]).to include("must be greater than or equal to 0")
    end
  end

  describe "#volume" do
    it "is required" do
      history.volume = nil
      history.valid?
      expect(history.errors[:volume]).to include("can't be blank")
    end

    it "is greater than or equal to 0" do
      history.volume = neg
      history.valid?
      expect(history.errors[:volume]).to include("must be greater than or equal to 0")
    end
  end

  describe "#change" do
    it "is required" do
      history.change = nil
      history.valid?
      expect(history.errors[:change]).to include("can't be blank")
    end
  end

  describe "#percent_change" do
    it "is required" do
      history.percent_change = nil
      history.valid?
      expect(history.errors[:percent_change]).to include("can't be blank")
    end
  end

  describe "#associations" do
    let(:use_db) { true }

    it "is destroyed when associated stock is destroyed" do
      expect { stock.destroy }.to change {
        PriceHistory.where(:id => history_in_db.id).count
      }.from(1).to(0)
    end
  end
end
