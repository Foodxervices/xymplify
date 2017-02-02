class InventoriesController < ApplicationController
  load_and_authorize_resource :restaurant
  load_and_authorize_resource :through => :restaurant, :shallow => true

  before_filter :detect_format, only: [:index]

  def index
    @kitchens = @restaurant.kitchens.accessible_by(current_ability)
    @kitchens = @kitchens.where(id: params[:kitchen_id])
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
            restaurant_id: @restaurant.id,
            can_update: can?(:update, i)
          }
        end
      end

      format.xlsx do
        @inventories = @inventories.where(exportable: true)
        @filename = "INVENTORY #{current_restaurant&.name} - #{current_kitchen&.name}"
        render xlsx: "index", filename: @filename
      end
    end
  end

  def show
    @kitchen = @inventory.kitchen
    @food_item = @inventory.food_item
  end

  def update
    if @inventory.update_attributes(inventory_params)
      render json: { success: true }
    else
      render json: { inventory: @inventory.reload, success: false }
    end
  end

  private

  def inventory_params
    params.require(:inventory).permit(
      :current_quantity
    )
  end

  def filter_params
    return @filter_params if @filter_params.present?

    filter_params = ActionController::Parameters.new(params[:inventory_filter])
    @filter_params ||= filter_params.permit(
      :keyword,
      :kitchen_id
    )
  end

  def detect_format
    request.format = "xlsx" if params[:commit] == 'Export'
  end
end