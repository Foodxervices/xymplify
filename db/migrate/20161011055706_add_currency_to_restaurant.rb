class AddCurrencyToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :currency, :string, default: "SGD"
  end
end
