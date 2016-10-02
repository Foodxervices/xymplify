class Version < PaperTrail::Version
  default_scope { order(created_at: :desc) }

  def user
    User.find_by_id(whodunnit) if whodunnit
  end  

  def self.by_restaurant(restaurant)
    kitchen_ids = restaurant.kitchens.ids
    food_item_ids = FoodItem.where(kitchen_id: kitchen_ids).ids 
    where("
            (item_type = 'Kitchen' AND item_id IN (:kitchen_ids)) OR 
            (item_type = 'FoodItem' AND item_id IN (:food_item_ids))
          ", kitchen_ids: kitchen_ids, food_item_ids: food_item_ids)
  end
end