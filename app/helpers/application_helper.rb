require 'numeric'

module ApplicationHelper
  def namespace
    controller.class.name.gsub(/(::)?\w+Controller$/, '')
  end

  def format_date(date)
    date.try(:strftime, '%a, %d %b %Y')
  end

  def format_datetime(date_time)
    date_time.try(:strftime, '%d %b %Y %I:%M %p')
  end

  def format_time(time)
    time.try(:strftime, '%I:%M %p')
  end

  def price_or_tba(price)
    return 'TBA' if price.to_f == 0
    humanized_money_with_symbol(price)
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

  def image_tag_retina_detection(name_at_1x, options={})
    name_at_2x = name_at_1x.gsub(%r{\.\w+$}, '-2x\0')
    image_tag(name_at_1x, options.merge("data-at2x" => ActionController::Base.helpers.asset_path(name_at_2x)))
  end

  def both_prices(food_item)
    arr = []
    if food_item.has_special_price?
      arr << "<i><strike>#{humanized_money_with_symbol(food_item.unit_price_without_promotion)}</strike></i>"
    end
    arr << price_or_tba(food_item.unit_price)
    arr.join(' / ').html_safe
  end
end