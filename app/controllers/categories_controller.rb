class CategoriesController < ApplicationController
  load_and_authorize_resource :restaurant
  load_and_authorize_resource :food_item, :through => :restaurant, :parent => false

  def index
    food_items = @food_items.accessible_by(current_ability, :order)
                            .joins("LEFT JOIN categories ON categories.id = food_items.category_id")
                            .select('cached_tag_list, categories.name category_name')
                            .order("CASE categories.name WHEN 'Others' THEN 1 ELSE 0 END, category_name, cached_tag_list ASC")
                            
    @categories = {}

    food_items.each do |food_item|
      @categories[food_item.category_name] ||= []
      
      food_item.tag_list.each do |tag|
        @categories[food_item.category_name] << tag if !@categories[food_item.category_name].include?(tag)
      end
    end

    @orders = Order.where(user_id: current_user.id, kitchen_id: @restaurant.kitchens, status: :wip)
  end
end