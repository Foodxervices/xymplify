class RemoveCurrentQuantityFromFoodItem < ActiveRecord::Migration
  def change
    remove_column :food_items, :current_quantity
    remove_column :food_items, :quantity_ordered
  end
end
