class AddMaxMinOrderQuantity < ActiveRecord::Migration
  def change
    add_column :food_items, :min_order_price, :decimal, precision: 12, scale: 2, default: 0.0
    add_column :food_items, :max_order_price, :decimal, precision: 12, scale: 2
  end
end
