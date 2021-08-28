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

  auto_strip_attributes :job_id, :error_message
  after_initialize :set_defaults

  validates :stock_id,      uniqueness: { scope: :model_config_id }
  validates :date_start,    presence: true
  validates :date_end,      presence: true
  validate  :date_start_before_date_end
  validates :stage,         presence: true
  validates :rmse,          presence: true, if: -> { done? }
  validates :rmse,          numericality: { allow_nil: true,
                                            greater_than_or_equal_to: 0 }
  validates :job_id,        presence: true, if: -> { enqueued? or training? or done? }
  validates :error_message, presence: true, if: -> { error? }


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
end
