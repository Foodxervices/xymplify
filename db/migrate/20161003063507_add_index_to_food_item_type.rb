class AddIndexToFoodItemType < ActiveRecord::Migration
  def change
    add_index :food_items, :type
  end
end
