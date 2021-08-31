class ModelTraining < ApplicationRecord
  belongs_to :model_config
  belongs_to :stock

  enum stage: {
    requested: 'requested',
    enqueued: 'enqueued',
    training: 'training',
    done: 'done',
    error: 'error'
  }

  auto_strip_attributes :error_message
  after_initialize      :set_defaults
  after_update          :update_model_config_train_percent,
                        if: -> { stage_changed_to_or_from_done? }

  validates :stock_id,      uniqueness: { scope: :model_config_id }
  validates :date_start,    presence: true
  validates :date_end,      presence: true
  validate  :date_start_before_date_end
  validates :stage,         presence: true
  validates :rmse,          presence: true, if: -> { done? }
  validates :rmse,          numericality: { allow_nil: true,
                                            greater_than_or_equal_to: 0 }
  validates :error_message, presence: true, if: -> { error? }


  def reset
    assign_attributes(stage: :requested, rmse: nil, error_message: nil)
    self
  end

  def reset!
    reset.save
    self
  end


  private

    def set_defaults
      self.stage ||= :requested
    end

    def date_start_before_date_end
      return if date_start.nil? or date_end.nil?
      if date_end < date_start
        errors.add(:date_end, "must be after or equal to date_start")
      end
    end

    def update_model_config_train_percent
      model_config.set_train_percent!
    end

    def stage_changed_to_or_from_done?
      return false unless saved_change_to_stage?
      stage_before_last_save == 'done' || done?
    end
end
