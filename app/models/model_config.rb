class ModelConfig < ApplicationRecord
  has_many :model_trainings,  dependent: :destroy
  has_many :stocks,           through: :model_trainings
  has_one  :training_schedule

  enum model_type: {lstm:'lstm', svm:'svm', rf:'rf'}

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


  def training?
    model_trainings.any? {|t| t.requested? or t.enqueued? or t.training?}
  end

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

  def reset_trainings(stock_ids = nil)
    date_s = parse_params[:start_date]
    date_e = Date.current.strftime('%Y-%m-%d')
    stock_ids ||= Stock.pluck(:id)

    stock_ids.each {|sid| reset_training(sid, date_s, date_e)}
    update(train_percent: 0)
    broadcast_training_progress
  end


  private

    def reset_training(stock_id, date_start, date_end)
      ref = { model_config_id: id, stock_id: stock_id }
      trng = ModelTraining.find_or_initialize_by(ref)
      trng.reset.assign_attributes(stage: :requested, date_start: date_start, date_end: date_end)
      trng.save
    end

    def broadcast_training_progress
      AdminChannel.broadcast EventMessages.model_config_training_progress(self)
    end
end
