require 'rails_helper'

RSpec.describe Session, type: :model do
  subject       { session }
  let(:session) { Session.new attributes_for(:user).slice(:email, :password) }

  before  { create :user }

  it { is_expected.to be_valid }

  describe "#email" do
    it "is required" do
      blank_strings.each do |email|
        session.email = email
        session.valid?
        expect(session.errors[:email]).to include("can't be blank")
      end
    end

    it "belongs to existing account" do
      session.email = 'unknown@email.com'
      session.valid?
      expect(session.errors[:email]).to include("not recognised")
    end
  end

  describe "#password" do
    it "is required" do
      blank_strings.each do |pw|
        session.password = pw
        session.valid?
        expect(session.errors[:password]).to include("can't be blank")
      end
    end

    it "matches account password" do
      session.password = 'incorrect'
      session.valid?
      expect(session.errors[:password]).to include("incorrect password")
    end
  end
end
