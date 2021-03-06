class AddUnitPriceToFoodItems < ActiveRecord::Migration
  def change
    remove_column :food_items, :unit_price, :decimal, precision: 12, scale: 2, default: 0.0
    add_monetize :food_items, :unit_price
    change_column_default :food_items, :unit_price_currency, nil
  end
end
