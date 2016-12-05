module LinksHelper 
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
      collection << link_to_if((cancan && can?(:dashboard, kitchen)), kitchen.name, [:dashboard, kitchen])
    end
    collection.join(", ").html_safe
  end

  def user_role_link(user, kitchen, linkable: true)
    return if user.nil? || kitchen.nil?
    return "Admin" if user.kind_of?(Admin)
    role = kitchen.get_role(user)
    return if role.nil?
    link_to_if(linkable && can?(:read, role), role.name, role, remote: true)
  end
end