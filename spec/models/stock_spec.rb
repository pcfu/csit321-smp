require 'rails_helper'

RSpec.describe Stock, type: :model do
  subject(:stock)   { build_stubbed :google }
  let(:ctrl_stock)  { create :facebook }

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
      stock.symbol = ctrl_stock.symbol
      stock.valid?
      expect(stock.errors[:symbol]).to include("has already been taken")
    end

    it "is upcased on validate" do
      stock = build_stubbed(:google, :symbol_lowercase)
      stock.valid?
      expect(stock.symbol).to eq(stock.symbol.upcase)
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
