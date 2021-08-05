class RemoveCompanyFromStock < ActiveRecord::Migration[6.1]
  def change
    remove_column :stocks, :company, :string
  end
end
