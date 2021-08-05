class AddNameToStock < ActiveRecord::Migration[6.1]
  def change
    add_column :stocks, :name, :string
  end
end
