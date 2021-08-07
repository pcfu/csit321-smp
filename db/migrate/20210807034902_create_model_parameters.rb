class CreateModelParameters < ActiveRecord::Migration[6.1]
  def change
    create_table :model_parameters do |t|
      t.string :name
      t.string :ml
      t.integer :param_one
      t.integer :param_two
      t.integer :param_three
      t.string :train_set
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
