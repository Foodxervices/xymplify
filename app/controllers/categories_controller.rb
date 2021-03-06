class CategoriesController < AdminController
  before_action :init, only: [:index, :by_supplier, :frequently_ordered]

  def index
    @food_items = @food_items.order("category_priority, category_name, supplier_priority, unit_price_cents")
    @groups = @food_items.group_by(&:category_name)
    @hide_category = true
  end

  def by_supplier
    @food_items = @food_items.order("supplier_priority, supplier_name, category_priority, unit_price_cents")
    @groups = @food_items.group_by(&:supplier_name)
    @hide_supplier = true
    render :index
  end

  def frequently_ordered
    @food_items = @food_items.order("ordered_count desc, supplier_priority, category_priority")
    @groups = { "Frequently Ordered" => @food_items }
    render :index
  end

  private

  def init
    authorize! :read, current_kitchen
    return redirect_to root_url if !current_kitchen
    @food_item_filter = FoodItemFilter.new(current_kitchen.food_items, food_item_filter_params)
    @food_items = @food_item_filter.result
    @food_items = @food_items.select("food_items.*, c.name as category_name, c.priority as category_priority, s.name as supplier_name, s.priority as supplier_priority")
                              .accessible_by(current_ability, :order)
                              .paginate(:page => params[:page])

    if !restaurant_owner?
      @food_items = @food_items.where(supplier_id: current_kitchen.suppliers.select(:id))
    end

    @categories = {}
  end

  def food_item_filter_params
    food_item_filter = ActionController::Parameters.new(params[:food_item_filter])
    data = food_item_filter.permit(
      :keyword,
      :supplier_id,
      :category_id,
      :kitchen_ids,
      :tag_list
    )
    data[:kitchen_ids] ||= current_kitchen&.id
    data[:kitchen_ids] = [data[:kitchen_ids].to_i] if data[:kitchen_ids].present?
    data
  end
end