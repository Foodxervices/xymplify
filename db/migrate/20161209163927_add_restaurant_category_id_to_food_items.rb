class AddRestaurantCategoryIdToFoodItems < ActiveRecord::Migration
  def change
    add_reference :food_items, :restaurant_category, index: true
  end
end
