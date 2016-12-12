class CategoriesController < ApplicationController
  load_and_authorize_resource :kitchen

  def index
    init
    @food_items = @food_items.includes(:taggings)
                             .select("food_items.id, cached_tag_list, category_name, category_ordered")
                             .order("category_ordered, cached_tag_list ASC")

    @food_items.each do |food_item|
      @categories[food_item.category_name] ||= {}
      
      food_item.tag_list.each do |tag|
        @categories[food_item.category_name][tag] ||= []
        @categories[food_item.category_name][tag] << food_item.id
      end
    end
  end

  def by_supplier
    init
    @food_items = @food_items.select("food_items.id, s.name as supplier_name, s.priority, category_name, category_ordered")
                             .order("s.priority, s.name, category_ordered ASC")

    @food_items.each do |food_item|
      @categories[food_item.supplier_name] ||= {}
      @categories[food_item.supplier_name][food_item.category_name] ||= []
      @categories[food_item.supplier_name][food_item.category_name] << food_item.id
    end

    render :index
  end

  private

  def init
    @food_item_filter = FoodItemFilter.new(@kitchen.food_items, food_item_filter_params)
    @food_items = @food_item_filter.result
                                 .accessible_by(current_ability, :order)
                                 .joins("LEFT JOIN (SELECT id, name as category_name, CASE name WHEN 'Uncategorised' THEN 2 WHEN 'Others' THEN 1 ELSE 0 END category_ordered 
                                                FROM categories) as categories 
                                                ON categories.id = food_items.category_id")

    @categories = {}
  end

  def food_item_filter_params
    food_item_filter = ActionController::Parameters.new(params[:food_item_filter])
    data = food_item_filter.permit(
      :keyword,
      :supplier_id,
      :kitchen_ids,
    )
    data[:kitchen_ids] ||= params[:kitchen_id]
    data[:kitchen_ids] = [data[:kitchen_ids].to_i] if data[:kitchen_ids].present?
    data
  end
end