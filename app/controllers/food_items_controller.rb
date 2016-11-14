class FoodItemsController < ApplicationController
  helper_method :sort_column, :sort_direction

  load_and_authorize_resource :restaurant
  load_and_authorize_resource :food_item, :through => :restaurant, :shallow => true, except: [:new]
  

  def index
    @food_item_filter = FoodItemFilter.new(@food_items, food_item_filter_params)
    @food_items =  @food_item_filter.result
                                    .select('food_items.*, suppliers.name as supplier_name, kitchens.name as kitchen_name')
                                    .includes(:supplier, :kitchen, :taggings)
                                    .order(sort_column + ' ' + sort_direction)
                                    .paginate(:page => params[:page])
  end

  def show; end

  def new 
    @food_item = FoodItem.new(unit_price_currency: "")
  end

  def create
    kitchens = current_restaurant.kitchens.accessible_by(current_ability)
    if food_item_params[:kitchen_id].to_i > 0
      kitchens = kitchens.where(id: food_item_params[:kitchen_id])
    end

    applied_count = 0

    if food_item_params[:code].present?
      ActiveRecord::Base.transaction do
        kitchens.includes(:restaurant).each do |kitchen|
          case food_item_params[:kitchen_id]
          when 'existed_food_items_only'
            @food_item = current_restaurant.food_items.where(code: food_item_params[:code], kitchen_id: kitchen).first
          else
            @food_item = current_restaurant.food_items.find_or_initialize_by(code: food_item_params[:code], kitchen_id: kitchen)
          end

          if @food_item.present?
            if (@food_item.new_record? && can?(:create, @food_item)) || (@food_item.persisted? && can?(:update, @food_item))
              @food_item.assign_attributes(food_item_params.merge(kitchen_id: kitchen.id))
              
              if @food_item.save
                applied_count += 1
              else
                @food_item.kitchen_id = food_item_params[:kitchen_id]
                return render :new
              end
            end
          end
        end
      end
    end

    redirect_to [@restaurant, :food_items], notice: "Your request was applied to #{applied_count} items."
  end

  def edit; end

  def update
    if ['all_kitchens', 'existed_food_items_only'].include?(food_item_params[:kitchen_id])
      @restaurant = @food_item.restaurant
      create
    else
      if @food_item.update_attributes(food_item_params)
        redirect_to [@food_item.restaurant, :food_items], notice: 'Food Item has been updated.'
      else
        render :edit
      end
    end
  end

  def destroy
    @food_item.destroy
    redirect_to :back, notice: 'Food Item has been deleted.'
  end

  private

  def food_item_filter_params
    food_item_filter = ActionController::Parameters.new(params[:food_item_filter])
    food_item_filter.permit(
      :keyword,
      :kitchen_id,
    )
  end

  def food_item_params
    data = params.require(:food_item).permit(
      :code,
      :name,
      :unit,
      :unit_price,
      :unit_price_without_promotion,
      :unit_price_currency,
      :supplier_id,
      :kitchen_id,
      :category_id,
      :brand,
      :image,
      :tag_list,
      :low_quantity
    )
    
    data[:unit_price]  = data[:unit_price_without_promotion] if data[:unit_price].to_f == 0
    data[:supplier_id] = current_restaurant.suppliers.accessible_by(current_ability).find(data[:supplier_id]).id if data[:supplier_id].present?
    data[:user_id] = current_user.id
    data
  end
  
  def sort_column
    FoodItem.column_names
            .push('supplier_name')
            .push('kitchen_name')
            .include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end