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

  def kitchen_dropdown(form, include_blank: true) 
    restaurants = Restaurant.accessible_by(current_ability).includes(:kitchens)
    form.input :kitchen_id, collection: restaurants, as: :grouped_select, group_method: :kitchens, include_blank: include_blank
  end
end
