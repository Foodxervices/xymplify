class FoodItemBelongsToCategory < ActiveRecord::Migration
  def change
    add_reference :food_items, :category, index: true
  end
end
