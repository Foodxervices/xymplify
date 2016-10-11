class ChangeQuantityType < ActiveRecord::Migration
  def change
    change_column :order_items, :quantity,        :decimal, precision: 8, scale: 2, default: 0.0
    change_column :food_items, :current_quantity, :decimal, precision: 8, scale: 2, default: 0.0
    change_column :food_items, :quantity_ordered, :decimal, precision: 8, scale: 2, default: 0.0
  end
end
