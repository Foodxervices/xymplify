class TagWorker
  include Sidekiq::Worker
  
  def perform(food_item_id)
    food_item = FoodItem.find(food_item_id)
    
    if food_item.tag_list.blank?
      food_item.tag_list = 'Others' 
      food_item.save 
    end

    category = RestaurantCategory.find_or_create_by(restaurant: food_item.restaurant, category: food_item.category)
    category.tag_list.add(food_item.cached_tag_list, parse: true)
    category.save
    
    if food_item.restaurant_category_id != category.id 
      restaurant_category_was = food_item.restaurant_category

      food_item.restaurant_category_id = category.id 
      food_item.save

      restaurant_category_was.destroy if restaurant_category_was && !restaurant_category_was.food_items.exists?
    end
  end
end