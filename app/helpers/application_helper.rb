require 'numeric'

module ApplicationHelper
  def currency_codes
    currencies = []
    Money::Currency.table.values.each do |currency|
      currencies = currencies + [[currency[:name] + ' (' + currency[:iso_code] + ')', currency[:iso_code]]]
    end
    currencies
  end

  def sortable(column, title: nil, kclass: controller_path.classify.constantize)
    column = column.to_s
    title ||= kclass.human_attribute_name(column)
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction), {:class => css_class}
  end

  def comma_seperated_for(list, field = :title)
    list.map(&field).join(', ') 
  end

  def comma_seperated_links_for(list, field = :title, cancan = true)
    collection = []
    list.collect do |item|
      value = item.send(field)
      if !value.blank?
        collection << link_to_if(!cancan || can?(:show, item), value, item)
      end
    end
    collection.join(", ").html_safe
  end

  def comma_seperated_links_for_kitchens(kitchens, cancan = true)
    collection = []
    kitchens.includes(:restaurant).each do |kitchen|
      collection << chicken_link(kitchen, cancan)
    end
    collection.join(", ").html_safe
  end

  def chicken_link(kitchen, cancan = true)
    return if kitchen.nil?
    link_to_if(!cancan || can?(:read, kitchen), kitchen.name, restaurant_food_items_url(kitchen.restaurant, food_item_filter: { kitchen_id: kitchen.id }))
  end

  def kitchen_dropdown(form, include_blank: true, action: :read, kitchens: Kitchen.all) 
    kitchens = kitchens.accessible_by(current_ability, action).includes(:restaurant)
    restaurants = {}
    kitchens.each do |kitchen|
      restaurants[kitchen.restaurant_id] ||= Restaurant.new(name: kitchen.restaurant&.name)
      restaurants[kitchen.restaurant_id].kitchens << kitchen
    end
    form.input :kitchen_id, collection: restaurants.values, as: :grouped_select, group_method: :kitchens, include_blank: include_blank
  end
end
