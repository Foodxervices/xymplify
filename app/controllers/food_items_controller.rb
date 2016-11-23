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

  def edit 
    @food_item.kitchen_ids = [@food_item.kitchen_id]
  end

  def create_or_update
    kitchens = current_restaurant.kitchens.accessible_by(current_ability)
                                 .where(id: food_item_params[:kitchen_ids])

    applied_kitchens = []
    
    if food_item_params[:code].present?
      ActiveRecord::Base.transaction do
        kitchens.includes(:restaurant).each do |kitchen|
          @food_item = current_restaurant.food_items.find_or_initialize_by(code: food_item_params[:code], kitchen_id: kitchen)

          if @food_item.present?
            if (@food_item.new_record? && can?(:create, @food_item)) || (@food_item.persisted? && can?(:update, @food_item))
              @food_item.assign_attributes(food_item_params.merge(kitchen_id: kitchen.id))

              if !@food_item.save
                return render :new
              else
                applied_kitchens << kitchen.name
              end
            end
          end
        end
      end
    end

    redirect_to [@restaurant, :food_items], 
              notice: "Your request was applied to #{applied_kitchens.join(', ')}. <br/> 
                       Visit <a href='#{restaurant_versions_path(current_restaurant)}'>history</a> to get more details."
  end

  def auto_populate
    @food_item = current_restaurant.food_items.accessible_by(current_ability).find_by_code(params[:code])
    @food_item.kitchen_ids = [@food_item.kitchen_id] if @food_item.present?
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
      :min_order_price,
      :max_order_price,
      :attachment_ids,
      kitchen_ids: [],
      files: []
    )
    
    data[:unit_price]  = data[:unit_price_without_promotion] if data[:unit_price].to_f == 0
    data[:supplier_id] = current_restaurant.suppliers.accessible_by(current_ability).find(data[:supplier_id]).id if data[:supplier_id].present?
    data[:user_id] = current_user.id
    data[:attachment_ids] = Attachment.where(id: data[:attachment_ids].split(',')).pluck(:id) if data[:attachment_ids].present?
    @food_item_params ||= data
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