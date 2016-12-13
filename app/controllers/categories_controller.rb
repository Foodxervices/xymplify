class CategoriesController < ApplicationController
  load_and_authorize_resource :kitchen

  def index
    init
    @food_items = @food_items.order("category_priority, supplier_priority ASC")
    @groups = @food_items.group_by(&:category_name)
    @hide_category = true
  end

  def by_supplier
    init
    @food_items = @food_items.order("supplier_priority, category_priority ASC")
    @groups = @food_items.group_by(&:supplier_name)
    @hide_supplier = true
    render :index
  end

  private

  def init
    @food_item_filter = FoodItemFilter.new(@kitchen.food_items, food_item_filter_params)
    @food_items = @food_item_filter.result
    @food_items = @food_items.select("food_items.*, c.name as category_name, c.priority as category_priority, s.name as supplier_name, s.priority as supplier_priority")
                              .accessible_by(current_ability, :order)
                              .paginate(:page => params[:page])

    @categories = {}
  end

  def food_item_filter_params
    food_item_filter = ActionController::Parameters.new(params[:food_item_filter])
    data = food_item_filter.permit(
      :keyword,
      :supplier_id,
      :category_id,
      :kitchen_ids,
    )
    data[:kitchen_ids] ||= params[:kitchen_id]
    data[:kitchen_ids] = [data[:kitchen_ids].to_i] if data[:kitchen_ids].present?
    data
  end
end