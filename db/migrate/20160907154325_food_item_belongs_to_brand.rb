class FoodItemBelongsToBrand < ActiveRecord::Migration
  def change
    add_reference :food_items, :brand, index: true
  end
end
