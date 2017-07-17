class AddPriceToDishes < ActiveRecord::Migration
  def change
    add_monetize :dishes, :price_without_profit
    add_monetize :dishes, :price
  end
end
