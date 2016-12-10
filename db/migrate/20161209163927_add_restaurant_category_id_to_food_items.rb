class AddRestaurantCategoryIdToFoodItems < ActiveRecord::Migration
  def change
    add_reference :food_items, :restaurant_category, index: true

    FoodItem.all.each do |food_item|
      TagWorker.perform_async(food_item.id)
    end
  end
end
