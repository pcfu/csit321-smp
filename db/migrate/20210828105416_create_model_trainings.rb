class CreateModelTrainings < ActiveRecord::Migration[6.1]
  def up
    create_enum :model_training_stage, %w(requested enqueued training done error)

    create_table :model_trainings do |t|
      t.references  :model_config,  null: false, foreign_key: true
      t.references  :stock,         null: false, foreign_key: true
      t.date        :date_start,    null: false
      t.date        :date_end,      null: false
      t.enum        :stage, enum_name: :model_training_stage, null: false, index: true
      t.decimal     :rmse
      t.string      :job_id
      t.text        :error_message

      t.timestamps
    end

    add_index :model_trainings, [:model_config_id, :stock_id], unique: true
  end

  def down
    remove_index :model_trainings, [:model_config_id, :stock_id]

    drop_table :model_trainings

    drop_enum :model_training_stage
  end
end
