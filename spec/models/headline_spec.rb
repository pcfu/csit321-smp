require 'rails_helper'

RSpec.describe Headline, type: :model do
  let(:stock)         { create :stock }
  subject(:headline)  { build_stubbed(:headline, :stock_id => stock.id) }

  it { is_expected.to be_valid }

  describe "#date" do
    it "is required" do
      headline.date = nil
      headline.valid?
      expect(headline.errors[:date]).to include("can't be blank")
    end
  end

  describe "#title" do
    it "is required" do
      blank_strings.each do |title|
        headline.title = title
        headline.valid?
        expect(headline.errors[:title]).to include("can't be blank")
      end
    end
  end

  describe "#associations" do
    it "is destroyed when associated stock is destroyed" do
      headline = create(:price_history, :stock_id => stock.id)
      stock.destroy
      expect(Headline.where(:id => headline.id)).to_not exist
    end
  end
end
