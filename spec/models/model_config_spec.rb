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
      let(:num_stocks)    { 10 }
      let(:num_trainings) { 9 }
      let(:num_done)      { rand(3..7) }

      it "returns itself" do
        expect(ctrl_config.set_train_percent).to eq(ctrl_config)
      end

      it "sets train_percent to ratio of done model_trainings / total stocks" do
        num_stocks.times do |i|
          stock = create :boilerplate_stock
          next if i >= num_trainings

          if i < num_done
            create(:model_training, :done, model_config_id: ctrl_config.id, stock_id: stock.id)
          else
            create(:model_training, model_config_id: ctrl_config.id, stock_id: stock.id)
          end
        end

        expected = (num_done.to_f / num_stocks * 100).to_i
        expect(ctrl_config.set_train_percent.train_percent).to eq(expected)
      end

      it "does not update" do
        ctrl_config.save
        expect(ctrl_config.set_train_percent.saved_change_to_train_percent?).to be false
      end
    end


    describe "set_train_percent!" do
      it "updates" do
        ctrl_config.save
        expect(ctrl_config.set_train_percent!.saved_change_to_train_percent?).to be true
      end
    end


    describe "reset_trainings" do
      before do
        10.times { create :boilerplate_stock }
      end

      let(:stock)  { Stock.first }
      let(:date_s) { Date.new(2020, 1, 1) }
      let(:date_e) { Date.new(2021, 1, 1) }

      it "sets train percent to 0" do
        ctrl_config.reset_trainings(date_s, date_e)
        expect(ctrl_config.reload.train_percent).to eq(0.0)
      end

      it "creates model_trainings if they don't exist" do
        expect {
          ctrl_config.reset_trainings(date_s, date_e, [stock.id])
        }.to change(ModelTraining, :count).by 1
      end

      it "does not create model_trainings if they exist" do
        trng = create(:full_training, model_config_id: ctrl_config.id, stock_id: stock.id)
        expect {
          ctrl_config.reset_trainings(date_s, date_e, [stock.id])
        }.to change(ModelTraining, :count).by 0
      end

      it "resets model_trainings to default states only for specified stocks" do
        Stock.pluck(:id).each do |sid|
          create(:full_training, model_config_id: ctrl_config.id, stock_id: sid)
        end

        reset_ids = Stock.limit(5).pluck(:id)
        ctrl_config.reset_trainings(date_s, date_e, reset_ids)

        trng_attrs = attributes_for(:full_training)
        ModelTraining.all.each do |trng|
          if trng.stock_id.in? reset_ids
            expect(trng.requested?).to be true
            expect(trng.rmse.nil?).to be true
            expect(trng.error_message.nil?).to be true
          else
            expect(trng.stage.to_s).to eq(trng_attrs[:stage].to_s)
            expect(trng.rmse).to eq(trng_attrs[:rmse])
            expect(trng.error_message).to eq(trng_attrs[:error_message])
          end
        end
      end

      context "when stocks ids not specified" do
        it "reset model_trainings for all stocks" do
          Stock.pluck(:id).each do |sid|
            create(:full_training, model_config_id: ctrl_config.id, stock_id: sid)
          end

          ctrl_config.reset_trainings(date_s, date_e)

          ModelTraining.all.each do |trng|
            expect(trng.requested?).to be true
            expect(trng.rmse.nil?).to be true
            expect(trng.error_message.nil?).to be true
          end
        end
      end
    end
  end
end
