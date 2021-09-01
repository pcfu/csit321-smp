require 'rails_helper'

RSpec.describe Stock, type: :model do
  subject                 { stock }
  let(:stock)             { build_stubbed :google, *traits }
  let(:traits)            { [] }
  let(:stock_in_db)       { create :facebook }

  it { is_expected.to be_valid }

  describe "#symbol" do
    it "is required" do
      blank_strings.each do |symbol|
        stock.symbol = symbol
        stock.valid?
        expect(stock.errors[:symbol]).to include("can't be blank")
      end
    end

    it "is unique" do
      stock.symbol = stock_in_db.symbol
      stock.valid?
      expect(stock.errors[:symbol]).to include("has already been taken")
    end

    context "when lowercase" do
      let(:traits) { [:symbol_lowercase] }

      it "is upcased on validate" do
        expect { stock.validate }.to change { stock.symbol }.from('goog').to('GOOG')
      end
    end
  end

  describe "#name" do
    it "is required" do
      blank_strings.each do |name|
        stock.name = name
        stock.valid?
        expect(stock.errors[:name]).to include("can't be blank")
      end
    end
  end

  describe "#exchange" do
    it "is required" do
      blank_strings.each do |exchange|
        stock.exchange = exchange
        stock.valid?
        expect(stock.errors[:exchange]).to include("can't be blank")
      end
    end
  end

  describe "#stock_type" do
    it "is required" do
      blank_strings.each do |type|
        stock.stock_type = type
        stock.valid?
        expect(stock.errors[:stock_type]).to include("can't be blank")
      end
    end
  end
end
