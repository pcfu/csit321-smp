class AddModeltypeToModelconfig < ActiveRecord::Migration[6.1]
  def change
    add_column :model_configs, :model_type, :integer
  end
end
