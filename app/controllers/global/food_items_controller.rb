class Global::FoodItemsController < AdminController
  helper_method :sort_column, :sort_direction
  before_action :authorize
  before_action :clear_restaurant_sessions

  def index
    @food_item_filter = FoodItemFilter.new(FoodItem.all, food_item_filter_params)
    @food_items =  @food_item_filter.result
                                    .select('food_items.*, r.name as restaurant_name, s.name as supplier_name, c.name as category_name')
                                    .joins("LEFT JOIN restaurants r ON food_items.restaurant_id = r.id")
                                    .includes(:supplier, :taggings)
                                    .order(sort_column + ' ' + sort_direction)
                                    .paginate(:page => params[:page])
  end

  def clone
    @form = CloneFoodItemService.new
  end

  def do_clone
    @form = CloneFoodItemService.new(clone_params)

    @form.call

    redirect_to global_food_items_path
  end

  private

  def food_item_filter_params
    food_item_filter = ActionController::Parameters.new(params[:food_item_filter])
    data = food_item_filter.permit(
      :keyword,
      :supplier_id,
      :category_id,
      :kitchen_ids,
      :tag_list
    )
    data
  end

  def clone_params
    data = params.require(:clone_food_item_service).permit(kitchen_ids: [])
    food_item = FoodItem.find(params[:id])
    data[:food_items] = [food_item]
    data[:supplier_id] = food_item.supplier_id
    data[:user_id] = current_user.id
    data
  end

  def authorize
    authorize! :global_food_items, User
  end

  def sort_column
    FoodItem.column_names
            .push('supplier_name')
            .push('category_name')
            .push('restaurant_name')
            .include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end