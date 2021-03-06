require 'numeric'

module DropdownHelper
  def kitchen_dropdown(form, action: :read, kitchens: Kitchen.all, multiple: true, include_blank: false)
    kitchens = kitchens.accessible_by(current_ability, action).includes(:restaurant)
    kitchens = kitchens.where(restaurant: current_restaurant) if current_restaurant.present?
    restaurants = {}
    kitchens.each do |kitchen|
      restaurants[kitchen.restaurant_id] ||= Restaurant.new(name: kitchen.restaurant&.name)
      restaurants[kitchen.restaurant_id].kitchens << kitchen
    end
    form.input :kitchen_ids, collection: restaurants.values, as: :grouped_select, group_method: :kitchens, include_blank: include_blank, input_html: {multiple: multiple, :'data-actions-box' => multiple}
  end

  def food_item_dropdown(form, include_blank: false)
    if current_kitchen
      food_items = current_kitchen.food_items
    else
      food_items = current_restaurant.food_items
    end

    food_items = food_items.joins(:supplier).accessible_by(current_ability).select('food_items.id, food_items.code, food_items.name, food_items.unit, suppliers.id as supplier_id, suppliers.name as supplier_name')
    suppliers = {}

    food_items.each do |f|
      suppliers[f.supplier_name] ||= []
      suppliers[f.supplier_name] << [f.id, "#{f.code} - #{f.name} [#{f.unit&.upcase}]"]
    end

    form.input :food_item_id, collection: suppliers, as: :grouped_select, group_method: :last, label_method: :last, value_method: :first
  end
end