class FoodItemsKitchen < ActiveRecord::Base 
  belongs_to :food_item
  belongs_to :kitchen
end