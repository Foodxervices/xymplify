class RemoveMoqFromFoodItems < ActiveRecord::Migration
  def change
    remove_column :food_items, :min_order_price
    remove_column :food_items, :max_order_price
  end
end
