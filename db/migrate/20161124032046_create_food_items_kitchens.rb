class CreateFoodItemsKitchens < ActiveRecord::Migration
  def change
    create_table :food_items_kitchens do |t|
      t.belongs_to :food_item
      t.belongs_to :kitchen
    end

    FoodItem.all.includes(:restaurant, restaurant: :kitchens).each do |food_item|
      food_item.restaurant.kitchens.each do |kitchen|
        kitchen.food_items << food_item
      end

      food_item.save
    end
  end
end
