require 'rails_helper'

RSpec.describe Headline, type: :model do
  subject               { headline }
  let(:headline)        { build_stubbed(:headline, stock: google) }
  let(:headline_in_db)  { create(:headline, stock: google) }
  let(:google)          { use_db ? create(:google) : build_stubbed(:google) }
  let(:use_db)          { false }

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
    let(:use_db) { true }

    it "is destroyed when associated stock is destroyed" do
      expect { google.destroy }.to change {
        Headline.where(:id => headline_in_db.id).count
      }.from(1).to(0)
    end
  end
end
