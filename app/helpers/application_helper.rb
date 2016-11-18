require 'numeric'

module ApplicationHelper
  def format_date(date)
    date.try(:strftime, '%a, %d %b %Y')
  end

  def format_datetime(date_time)
    date_time.try(:strftime, '%d %b %Y %I:%M %p')
  end
  
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

  def kitchen_dropdown(form, include_blank: true, action: :read, kitchens: Kitchen.all) 
    kitchens = kitchens.accessible_by(current_ability, action).includes(:restaurant)
    kitchens = kitchens.where(restaurant: current_restaurant) if current_restaurant.present?
    restaurants = {}
    kitchens.each do |kitchen|
      restaurants[kitchen.restaurant_id] ||= Restaurant.new(name: kitchen.restaurant&.name)
      restaurants[kitchen.restaurant_id].kitchens << kitchen
    end
    form.input :kitchen_id, collection: restaurants.values, as: :grouped_select, group_method: :kitchens, include_blank: include_blank
  end

  def image_tag_retina_detection(name_at_1x, options={})
    name_at_2x = name_at_1x.gsub(%r{\.\w+$}, '-2x\0')
    image_tag(name_at_1x, options.merge("data-at2x" => ActionController::Base.helpers.asset_path(name_at_2x)))
  end

  def both_prices(food_item)
    arr = []
    if food_item.has_special_price?
      arr << "<i><strike>#{humanized_money_with_symbol(food_item.unit_price_without_promotion)}</strike></i>"
    end
    arr << humanized_money_with_symbol(food_item.unit_price)
    arr.join(' / ').html_safe
  end

  def format_price(price, currency_code)
    humanized_money_with_symbol(Money.from_amount(price.to_f, currency_code))
  end
end
