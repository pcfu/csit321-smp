class CreateRecommendations < ActiveRecord::Migration[6.1]

  def up
    create_enum :recommendation_verdict, %w(buy hold sell)

    create_table :recommendations do |t|
      t.references :stock, null: false, foreign_key: true
      t.date       :entry_date, null: false
      t.date       :nd_date
      t.enum       :nd_verdict, enum_name: :recommendation_verdict
      t.date       :st_date
      t.enum       :st_verdict, enum_name: :recommendation_verdict
      t.date       :mt_date
      t.enum       :mt_verdict, enum_name: :recommendation_verdict

      t.timestamps
    end

    add_index :recommendations, [:stock_id, :entry_date]
  end

  def down
    remove_index :recommendations, [:stock_id, :entry_date]

    drop_table :recommendations

    drop_enum :recommendation_verdict
  end

end
