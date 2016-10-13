class CategoriesController < ApplicationController
  load_and_authorize_resource :restaurant
  load_and_authorize_resource :food_item, :through => :restaurant, :parent => false

  def index
    @food_item_filter = FoodItemFilter.new(@food_items, food_item_filter_params)
    @food_items = @food_item_filter.result
                                 .includes(:taggings)
                                 .select("food_items.id, cached_tag_list, category_name, category_ordered")
                                 .accessible_by(current_ability, :order)
                                 .joins("LEFT JOIN (SELECT id, name as category_name, CASE name WHEN 'Others' THEN 1 ELSE 0 END category_ordered 
                                                    FROM categories) as categories 
                                                    ON categories.id = food_items.category_id")
                                 .order("category_ordered, cached_tag_list ASC")

    @categories = {}

    @food_items.each do |food_item|
      @categories[food_item.category_name] ||= {}
      
      food_item.tag_list.each do |tag|
        @categories[food_item.category_name][tag] ||= []
        @categories[food_item.category_name][tag] << food_item.id
      end
    end

    @orders = Order.where(user_id: current_user.id, kitchen_id: @restaurant.kitchens, status: :wip)
  end

  private

  def food_item_filter_params
    food_item_filter = ActionController::Parameters.new(params[:food_item_filter])
    food_item_filter.permit(
      :keyword,
      :kitchen_id,
    )
  end
end