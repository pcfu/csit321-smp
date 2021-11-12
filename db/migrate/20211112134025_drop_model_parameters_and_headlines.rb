class DropModelParametersAndHeadlines < ActiveRecord::Migration[6.1]
  def up
    drop_table :headlines
    drop_table :model_parameters
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
