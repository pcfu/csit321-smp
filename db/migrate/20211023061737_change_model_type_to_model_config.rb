class ChangeModelTypeToModelConfig < ActiveRecord::Migration[6.1]
 
  def up
    remove_column :model_configs, :model_type 
    
    end

  def down
    add_column :model_configs, :model_type, :integer
  end

end
