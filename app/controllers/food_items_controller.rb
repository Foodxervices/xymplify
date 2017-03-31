class FoodItemsController < AdminController
  helper_method :sort_column, :sort_direction

  load_and_authorize_resource :food_item, :through => :current_restaurant, except: [:new]


  def index
    @food_item_filter = FoodItemFilter.new(@food_items, food_item_filter_params)
    @food_items =  @food_item_filter.result
                                    .select('food_items.*, s.name as supplier_name, c.name as category_name')
                                    .includes(:supplier)
                                    .order(sort_column + ' ' + sort_direction)
                                    .paginate(:page => params[:page])
    if current_kitchen.nil?
      @food_items = @food_items.includes(:kitchens)
    else
      if !restaurant_owner?
        @food_items = @food_items.where(supplier_id: current_kitchen.suppliers.select(:id))
      end
    end
  end

  def show
    @kitchens = @food_item.kitchens.accessible_by(current_ability).load
  end

  def new
    @food_item = FoodItem.new(unit_price_currency: "")
  end

  def create
    if @food_item.save
      redirect_to @food_item, notice: 'Food Item has been created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @food_item.update_attributes(food_item_params)
      redirect_to @food_item, notice: 'Food Item has been updated.'
    else
      render :edit
    end
  end

  def destroy
    if @food_item.destroy
      flash[:notice] = 'Food Item has been deleted.'
    else
      flash[:notice] = @food_item.errors.full_messages.join("<br />")
    end

    redirect_to :back
  end

  private

  def food_item_filter_params
    food_item_filter = ActionController::Parameters.new(params[:food_item_filter])
    data = food_item_filter.permit(
      :keyword,
      :supplier_id,
      :category_id,
      :kitchen_ids
    )

    data[:kitchen_ids] ||= current_kitchen&.id
    data[:kitchen_ids] = [data[:kitchen_ids].to_i] if data[:kitchen_ids].present?
    data
  end

  def food_item_params
    return @food_item_params if @food_item_params.present?

    data = params.require(:food_item).permit(
      :code,
      :name,
      :unit,
      :unit_price,
      :unit_price_without_promotion,
      :unit_price_currency,
      :supplier_id,
      :category_id,
      :brand,
      :image,
      :tag_list,
      :low_quantity,
      :country_of_origin,
      kitchen_ids: []
    )

    data[:unit_price]  = data[:unit_price_without_promotion] if data[:unit_price].to_f == 0
    data[:supplier_id] = current_restaurant.suppliers.accessible_by(current_ability).find(data[:supplier_id]).id if data[:supplier_id].present?
    data[:kitchen_ids] = current_restaurant.kitchens.where(id: data[:kitchen_ids]).ids if data[:kitchen_ids].present?
    data[:restaurant_id] = current_restaurant.id if current_restaurant.present?
    data[:user_id] = current_user.id
    data[:attachment_ids] = Attachment.where(id: params[:attachment_ids].split(',')).pluck(:id) if params[:attachment_ids].present?
    @food_item_params ||= data
  end

  def sort_column
    FoodItem.column_names
            .push('supplier_name')
            .push('category_name')
            .include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end