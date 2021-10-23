class UpdateModelConfig < ActiveRecord::Migration[6.1]
  def up
    add_column :model_configs, :active, :boolean
    create_enum :ml_name, %w(lstm svm rf)
    add_column :model_configs, :model_type, :ml_name
    
    end
    

  def down
    remove_column :model_configs, :active
    drop_enum :ml_name
    drop_column :model_configs, :model_type
  end

end