class CreateHeadlines < ActiveRecord::Migration[6.1]
  def up
    create_table :headlines do |t|
      t.references  :stock, null: false, foreign_key: true
      t.date        :date,  null: false
      t.text        :title, null: false

      t.timestamps
    end

    add_index :headlines, [:stock_id, :date]
    add_index :headlines, :date
  end

  def down
    remove_index :headlines, :date
    remove_index :headlines, [:stock_id, :date]

    drop_table :headlines
  end
end
