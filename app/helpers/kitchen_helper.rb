require 'numeric'

module KitchenHelper
  def kitchen_dropdown(form, action: :read, kitchens: Kitchen.all, multiple: true, include_blank: false) 
    kitchens = kitchens.accessible_by(current_ability, action).includes(:restaurant)
    kitchens = kitchens.where(restaurant: current_restaurant) if current_restaurant.present?
    restaurants = {}
    kitchens.each do |kitchen|
      restaurants[kitchen.restaurant_id] ||= Restaurant.new(name: kitchen.restaurant&.name)
      restaurants[kitchen.restaurant_id].kitchens << kitchen
    end
    form.input :kitchen_ids, collection: restaurants.values, as: :grouped_select, group_method: :kitchens, include_blank: include_blank, input_html: {multiple: multiple}
  end
end
