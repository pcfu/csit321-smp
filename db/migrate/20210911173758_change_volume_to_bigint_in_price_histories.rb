class ChangeVolumeToBigintInPriceHistories < ActiveRecord::Migration[6.1]
  def up
    change_column :price_histories, :volume, :bigint
  end

  def down
    change_column :price_histories, :volume, :integer
  end
end
