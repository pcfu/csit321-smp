require 'rails_helper'

RSpec.describe User, type: :model do
  subject           { user }
  let(:user)        { build_stubbed(:user, *traits) }
  let(:user_in_db)  { create(:user, *traits) }
  let(:traits)      { [] }
  let(:use_db)      { false }

  it { is_expected.to be_valid }

  describe "#first_name" do
    it "is required" do
      blank_strings.each do |fname|
        user.first_name = fname
        user.valid?
        expect(user.errors[:first_name]).to include("can't be blank")
      end
    end

    it "has no spaces" do
      traits << :first_name_with_spaces
      user.valid?
      expect(user.errors[:first_name]).to include("is invalid")
    end

    it "has no numbers" do
      traits << :first_name_with_number
      user.valid?
      expect(user.errors[:first_name]).to include("is invalid")
    end

    it "has no special characters" do
      special_chars.split('').each do |char|
        user.first_name += char
        user.valid?
        expect(user.errors[:first_name]).to include("is invalid")
      end
    end

    context "when uppercase" do
      it "is downcased on validate" do
        traits << :first_name_uppercase
        fname_upper = user.first_name

        expect { user.validate }.to change {
          user.first_name
        }.from(fname_upper).to(fname_upper.downcase)
      end
    end
  end

  describe "#last_name" do
    it "is required" do
      blank_strings.each do |lname|
        user.last_name = lname
        user.valid?
        expect(user.errors[:last_name]).to include("can't be blank")
      end
    end

    it "has no spaces" do
      traits << :last_name_with_spaces
      user.valid?
      expect(user.errors[:last_name]).to include("is invalid")
    end

    it "has no numbers" do
      traits << :last_name_with_number
      user.valid?
      expect(user.errors[:last_name]).to include("is invalid")
    end

    it "has no special characters" do
      special_chars.split('').each do |char|
        user.last_name += char
        user.valid?
        expect(user.errors[:last_name]).to include("is invalid")
      end
    end

    context "when uppercase" do
      it "is downcased on validate" do
        traits << :last_name_uppercase
        lname_upper = user.last_name

        expect { user.validate }.to change {
          user.last_name
        }.from(lname_upper).to(lname_upper.downcase)
      end
    end
  end

  describe "#email" do
    it "is required" do
      blank_strings.each do |email|
        user.email = email
        user.valid?
        expect(user.errors[:email]).to include("can't be blank")
      end
    end

    it "has no spaces" do
      traits << :email_with_spaces
      user.valid?
      expect(user.errors[:email]).to include("is invalid")
    end

    it "has a username" do
      traits << :email_no_username
      user.valid?
      expect(user.errors[:email]).to include("is invalid")
    end

    it "has an @ symbol" do
      traits << :email_no_at_symbol
      user.valid?
      expect(user.errors[:email]).to include("is invalid")
    end

    it "has a domain name" do
      traits << :email_no_domain_name
      user.valid?
      expect(user.errors[:email]).to include("is invalid")
    end

    it "has a top-level domain name" do
      traits << :email_no_top_level_domain
      user.valid?
      expect(user.errors[:email]).to include("is invalid")
    end

    it "is unique" do
      user.email = user_in_db.email
      user.valid?
      expect(user.errors[:email]).to include("has already been taken")
    end

    context "when uppercase" do
      it "is downcased on validate" do
        traits << :email_uppercase
        email_upper = user.email

        expect { user.validate }.to change {
          user.email
        }.from(email_upper).to(email_upper.downcase)
      end
    end
  end

  describe "#password" do
    it "is required" do
      blank_strings.each do |password|
        user.password = password
        user.valid?
        expect(user.errors[:password]).to include("can't be blank")
      end
    end

    it "has at least #{User::PW_MIN_LEN} characters" do
      traits << :pw_too_short
      user.valid?
      expect(user.errors[:password]).to include(/is too short/)
    end

    it "has at most #{User::PW_MAX_LEN} characters" do
      traits << :pw_too_long
      user.valid?
      expect(user.errors[:password]).to include(/is too long/)
    end

    it "has no spaces" do
      traits << :pw_with_spaces
      user.valid?
      expect(user.errors[:password]).to include("is invalid")
    end

    it "has at least 1 uppercase character" do
      traits << :pw_lowercase
      user.valid?
      expect(user.errors[:password]).to include("is invalid")
    end

    it "has at least 1 lowercase character" do
      traits << :pw_uppercase
      user.valid?
      expect(user.errors[:password]).to include("is invalid")
    end

    it "has at least 1 number" do
      traits << :pw_no_numbers
      user.valid?
      expect(user.errors[:password]).to include("is invalid")
    end

    it "has at least 1 special character" do
      traits << :pw_no_special_chars
      user.valid?
      expect(user.errors[:password]).to include("is invalid")
    end
  end

  describe "#password_confirmation" do
    it "is equal to password" do
      traits << :pw_not_equal_confirmation
      user.valid?
      expect(user.errors[:password_confirmation]).to include("doesn't match Password")
    end
  end

  describe "#role" do
    it "is required" do
      user.role = nil
      user.valid?
      expect(user.errors[:role]).to include("can't be blank")
    end

    it "accepts only enum values" do
      traits << :invalid_role
      expect { user }.to raise_error(ArgumentError).with_message(/is not a valid role/)
    end
  end
end
