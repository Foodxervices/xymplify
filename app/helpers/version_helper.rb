module VersionHelper
  def version_value(field, value) 
    if ['kitchen_id', 'supplier_id', 'user_id', 'role_id', 'restaurant_id', 'user_role_id', 'category_id'].include?(field)
      field = field.gsub("_id", "")

      kclass = field.classify.constantize

      object = kclass.find_by_id(value)

      if object.present?
        if ['category_id'].includes?(field)
          value = object&.name
        else
          object = object.becomes(User) if object.kind_of?(Admin)
          value = link_to_if(can?(:show, object), object&.name, object, remote: true) 
        end
      end
    end

    value
  end
end
