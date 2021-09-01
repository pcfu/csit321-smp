require 'rails_helper'

RSpec.describe Headline, type: :model do
  subject               { headline }
  let(:headline)        { build_stubbed(:headline, stock: google) }
  let(:headline_in_db)  { create(:headline, stock: google) }
  let(:google)          { create :google }

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
      id = headline_in_db.id
      google.destroy
      expect(Headline.where(:id => headline.id)).to_not exist
    end
  end
end
