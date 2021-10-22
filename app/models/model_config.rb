class ModelConfig < ApplicationRecord
  has_many :model_trainings,  dependent: :destroy
  has_many :stocks,           through: :model_trainings

  auto_strip_attributes :name, :params
  after_update :broadcast_training_progress,
               if: -> { train_percent_before_last_save < train_percent }

  validates :name,          presence: true, uniqueness: { case_sensitive: false }
  validates :params,        presence: true,
                            json_string: { allow_nil: true,
                                           parses_to: [ Hash ],
                                           parses_to_blank: false }
  validates :train_percent, presence: true,
                            numericality: { allow_nil: true,
                                            greater_than_or_equal_to: 0,
                                            less_than_or_equal_to: 100 }


  def parse_params
    JSON.parse(params, symbolize_names: true)
  end

  def set_train_percent
    percent = model_trainings.done.count.to_f / Stock.count * 100 || 0
    assign_attributes(train_percent: percent.nan? ? 0 : percent.to_i)
    self
  end

  def set_train_percent!
    set_train_percent.save
    self
  end

  def reset_trainings(date_start, date_end, stock_ids = nil)
    stock_ids ||= Stock.pluck(:id)
    stock_ids.each {|sid| reset_training(date_start, date_end, sid)}
    update(train_percent: 0)
    broadcast_training_progress
  end


  private

    def reset_training(date_start, date_end, stock_id)
      ref = { model_config_id: id, stock_id: stock_id }
      trng = ModelTraining.find_or_initialize_by(ref)
      trng.reset.assign_attributes(date_start: date_start, date_end: date_end)
      trng.save
    end

    def broadcast_training_progress
      AdminChannel.broadcast EventMessages.model_config_training_progress(self)
    end

    #Declare model_type enum
    #enum model_type: {lstm:'lstm', svm:'svm', rf:'rf'}


end
