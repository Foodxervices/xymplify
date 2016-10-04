class CategoriesController < ApplicationController
  load_and_authorize_resource :restaurant
  load_and_authorize_resource :food_item, :through => :restaurant, :parent => false

  def index
    food_items = @food_items.joins("LEFT JOIN categories ON categories.id = food_items.category_id")
                            .select('type, categories.name category_name')
                            .order("CASE categories.name WHEN 'Others' THEN 1 ELSE 0 END, category_name, type ASC")
                            
    @categories = {}

    food_items.each do |food_item|
      @categories[food_item.category_name] ||= []
      @categories[food_item.category_name] << food_item.type if !@categories[food_item.category_name].include?(food_item.type)
    end

    @orders = Order.where(user_id: current_user.id, kitchen_id: @restaurant.kitchens, status: :wip)
  end
end