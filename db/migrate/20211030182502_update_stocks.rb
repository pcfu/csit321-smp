class UpdateStocks < ActiveRecord::Migration[6.1]
  def up
    create_enum :stock_industry, %w(technology energy healthcare)

    change_table :stocks do |t|
      t.remove :stock_type, :description
      t.enum   :industry, enum_name: :stock_industry
    end
  end

  def down
    change_table :stocks do |t|
      t.remove :industry
      t.string :stock_type
      t.text   :description
    end

    drop_enum :stock_industry
  end
end
