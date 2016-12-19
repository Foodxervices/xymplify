module VersionHelper
  def version_value(field, value, linkable: true) 
    if ['kitchen_id', 'supplier_id', 'user_id', 'role_id', 'restaurant_id', 'user_role_id', 'category_id', 'order_id', 'food_item_id'].include?(field)
      field = field.gsub("_id", "")

      kclass = field.classify.constantize

      object = kclass.find_by_id(value)

      if object.present?
        if ['category'].include?(field)
          value = object&.name
        else
          object = object.becomes(User) if object.kind_of?(Admin)
          value = link_to_if(linkable && can?(:show, object), object&.name, object, remote: true) 
        end
      end
    elsif field == 'unit_price_cents'
      value = value.to_f / 100
    elsif field == 'file_file_name'
      value = value.ellipsisize('long')
    elsif  field =~ /[.]*_at$/ #created_at, updated_at...
      value = format_datetime(value)
    elsif  field =~ /[.]*_on$/ #created_on, updated_on...
      value = format_date(value)
    end

    value
  end

  def version_title(version)
    currency_code = version.item.try(:unit_price_currency) || version.item.try(:amount_currency)
    currency_code = "(#{currency_code})" if currency_code.present?
    "#{version.item&.name} #{currency_code}"
  end
end
