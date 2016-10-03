class AddRestaurantIdToFoodItems < ActiveRecord::Migration
  def change
    add_reference :food_items, :restaurant, index: true
  end
end
