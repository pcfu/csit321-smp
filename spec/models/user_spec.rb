require 'rails_helper'

RSpec.describe User, type: :model do
  subject           { user }
  let(:user)        { build_stubbed(:user, *traits) }
  let(:user_in_db)  { create(:user, *traits) }
  let(:traits)      { [] }
  let(:use_db)      { false }

  it { is_expected.to be_valid }
end
