class UpdateRecommendations < ActiveRecord::Migration[6.1]
  def up
    remove_index :recommendations, [:stock_id, :entry_date], if_exists: true

    change_table :recommendations do |t|
      t.remove :entry_date, :nd_date, :nd_verdict,
               :st_date, :st_verdict, :mt_date, :mt_verdict

      t.date   :prediction_date, null: false
      t.enum   :verdict, enum_name: :recommendation_verdict
    end

    add_index :recommendations, [:stock_id, :prediction_date]
  end

  def down
    remove_index :recommendations, [:stock_id, :prediction_date], if_exists: true

    change_table :recommendations do |t|
      t.remove  :prediction_date, :verdict

      t.date    :entry_date, null: false
      t.date    :nd_date
      t.enum    :nd_verdict, enum_name: :recommendation_verdict
      t.date    :st_date
      t.enum    :st_verdict, enum_name: :recommendation_verdict
      t.date    :mt_date
      t.enum    :mt_verdict, enum_name: :recommendation_verdict
    end

    add_index :recommendations, [:stock_id, :entry_date]
  end
end
