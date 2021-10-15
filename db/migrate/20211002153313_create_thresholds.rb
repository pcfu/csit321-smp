class CreateThresholds < ActiveRecord::Migration[6.1]
  def change
    create_table :thresholds do |t|
      t.references :favorite, null: false, foreign_key: true

      t.timestamps
    end
  end
end
