class RemoveJobIdFromModelTrainings < ActiveRecord::Migration[6.1]
  def change
    remove_column :model_trainings, :job_id, if_exists: true
  end
end
