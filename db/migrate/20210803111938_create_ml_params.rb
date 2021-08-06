class CreateMlParams < ActiveRecord::Migration[6.1]
  def change
    create_table :ml_params do |t|
      t.string :name
      t.string :ml
      t.integer :paraOne
      t.integer :paraTwo
      t.integer :paraThree
      t.string :trainSet
      t.date :startDate
      t.date :endDate

      t.timestamps
    end
  end
end
