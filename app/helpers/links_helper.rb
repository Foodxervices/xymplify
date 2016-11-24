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
      collection << chicken_link(kitchen, cancan)
    end
    collection.join(", ").html_safe
  end

  def chicken_link(kitchen, cancan = true)
    return if kitchen.nil?
    link_to_if(!cancan || can?(:read, kitchen), kitchen.name, [kitchen.restaurant, kitchen, :food_items])
  end
end