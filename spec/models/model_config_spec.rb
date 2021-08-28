require 'rails_helper'

RSpec.describe ModelConfig, type: :model do
  let(:ctrl_config) { create :ctrl_config }
  subject(:config)  { build_stubbed :model_config }

  it { is_expected.to be_valid }

  describe "#name" do
    it "is required" do
      blank_strings.each do |name|
        config.name = name
        config.valid?
        expect(config.errors[:name]).to include("can't be blank")
      end
    end

    it "is case-insensitive unique" do
      config.name = ctrl_config.name.upcase
      config.valid?
      expect(config.errors[:name]).to include("has already been taken")
    end
  end

  describe "#params" do
    it "is required" do
      blank_strings.each do |params|
        config.params = params
        config.valid?
        expect(config.errors[:params]).to include("can't be blank")
      end
    end

    it "is a valid json string" do
      config = build_stubbed(:model_config, :params_invalid_json)
      config.valid?
      expect(config.errors[:params]).to include("is not a valid json string")
    end

    it "parses into a hash" do
      %i[params_string params_integer params_array].each do |trait|
        config = build_stubbed(:model_config, trait)
        config.valid?
        expect(config.errors[:params]).to include("is not a valid json string")
      end
    end

    it "does not parse into empty hash" do
      config = build_stubbed(:model_config, :params_empty_hash)
      config.valid?
      expect(config.errors[:params]).to include("is not a valid json string")
    end
  end

  describe "#train_percent" do
    it "is required" do
      config.train_percent = nil
      config.valid?
      expect(config.errors[:train_percent]).to include("can't be blank")
    end

    it "is at least 0" do
      config = build_stubbed(:model_config, :train_percent_under_0)
      config.valid?
      expect(config.errors[:train_percent]).to include("must be greater than or equal to 0")
    end

    it "is at most 100" do
      config = build_stubbed(:model_config, :train_percent_above_100)
      config.valid?
      expect(config.errors[:train_percent]).to include("must be less than or equal to 100")
    end
  end

  describe "#methods" do
    describe "set_train_percent" do
      let(:num_stocks) { 9 }
      let(:num_done)   { rand(3..7) }
      subject(:config) { create :model_config }

      it "sets train_percent to ratio of done model_trainings / total modal_trainings" do
        num_stocks.times do |i|
          stock = create :boilerplate_stock
          if i < num_done
            create(:model_training, :done, model_config_id: config.id, stock_id: stock.id)
          else
            create(:model_training, model_config_id: config.id, stock_id: stock.id)
          end
        end

        expected = (num_done.to_f / num_stocks * 100).to_i
        expect(config.set_train_percent.train_percent).to eq(expected)
      end
    end
  end
end
