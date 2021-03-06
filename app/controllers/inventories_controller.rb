class InventoriesController < AdminController
  load_and_authorize_resource :through => :current_kitchen, :shallow => true

  before_filter :detect_format, only: [:index]

  def index
    @inventory_filter = InventoryFilter.new(@inventories, filter_params)
    @inventories = @inventory_filter.result
                                    .select('
                                        inventories.id as id, inventories.current_quantity, inventories.quantity_ordered, inventories.food_item_id, inventories.kitchen_id,
                                        s.name as supplier_name,
                                        c.name as category_name
                                        ')
                                    .includes(:food_item)
                                    .order(current_quantity: :desc, quantity_ordered: :desc)

    respond_to do |format|
      format.html do
        @inventories = @inventories.paginate(:page => params[:page])

        @groups = {}

        @inventories.each do |i|
          food_item = i.food_item
          @groups[food_item.name] ||= []

          @groups[food_item.name] << {
            id: i.id,
            food_item_id: i.food_item_id,
            name: food_item.name,
            supplier_name: i.supplier_name,
            category_name: i.category_name,
            current_quantity: i.current_quantity,
            quantity_ordered: i.quantity_ordered,
            unit: food_item.unit,
            unit_price: food_item.unit_price.dollars,
            default_unit_price: food_item.unit_price.exchange_to(current_restaurant.currency).dollars,
            symbol: food_item.unit_price.symbol,
            kitchen_id: i.kitchen_id,
            restaurant_id: current_restaurant.id,
            can_update: can?(:update, i)
          }
        end
      end

      format.xlsx do
        @filename = "INVENTORY #{current_restaurant.name} - #{current_kitchen.name}"
        render xlsx: "index", filename: @filename
      end
    end
  end

  def show
    @kitchen = @inventory.kitchen
    @food_item = @inventory.food_item
  end

  def update
    @quantity_was = @inventory.current_quantity
    
    if !@inventory.update_attributes(inventory_params)
      return render json: { inventory: @inventory.reload, success: false }
    end
  end

  private

  def inventory_params
    data = params.require(:inventory).permit(
      :current_quantity
    )
    data
  end

  def filter_params
    return @filter_params if @filter_params.present?

    @filter_params = ActionController::Parameters.new(params[:inventory_filter])
    @filter_params ||= @filter_params.permit(
      :keyword,
      :tag_list
    )
    @filter_params[:kitchen_id] = current_kitchen&.id
    @filter_params
  end

  def detect_format
    request.format = "xlsx" if params[:commit] == 'Export'
  end
end