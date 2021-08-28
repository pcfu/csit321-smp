class CreateModelConfigs < ActiveRecord::Migration[6.1]
  def change
    create_table :model_configs do |t|
      t.string :name,           null: false, index: { unique: true }
      t.text :params,           null: false
      t.integer :train_percent, null: false

      t.timestamps
    end
  end
end
