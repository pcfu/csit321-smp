class AddAccuracyAndParametersToModelTrainings < ActiveRecord::Migration[6.1]
  def change
    change_table :model_trainings do |t|
      t.decimal :accuracy
      t.text    :parameters
    end
  end
end
