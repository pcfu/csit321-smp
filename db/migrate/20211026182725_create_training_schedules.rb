class CreateTrainingSchedules < ActiveRecord::Migration[6.1]
  def change
    create_table :training_schedules do |t|
      t.references :model_config, null: false, foreign_key: true
      t.date :start_date
      t.integer :frequency

      t.timestamps
    end
  end
end
