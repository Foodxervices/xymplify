class Version < PaperTrail::Version
  default_scope { order(created_at: :desc) }

  def user
    User.find_by_id(whodunnit) if whodunnit
  end  

  def self.accessible_by(current_ability, restaurant_id: nil)
    kitchens    = Kitchen.accessible_by(current_ability)
    suppliers   = Supplier.accessible_by(current_ability)
    user_roles  = UserRole.accessible_by(current_ability)

    if restaurant_id.present?
      kitchens    = kitchens.where(restaurant_id: restaurant_id) 
      suppliers   = suppliers.where(restaurant_id: restaurant_id) 
      user_roles  = user_roles.where(restaurant_id: restaurant_id) 
    end

    food_items = FoodItem.where(kitchen_id: kitchens)
    
    where("
        (item_type = 'Restaurant' AND item_id IN (:restaurant_id)) OR 
        (item_type = 'Kitchen' AND item_id IN (:kitchen_ids)) OR 
        (item_type = 'FoodItem' AND item_id IN (:food_item_ids)) OR
        (item_type = 'UserRole' AND item_id IN (:user_role_ids)) OR
        (item_type = 'Supplier' AND item_id IN (:supplier_ids)) 
      ", 
        restaurant_id:  restaurant_id || Restaurant.accessible_by(current_ability).ids, 
        kitchen_ids:    kitchens.ids, 
        food_item_ids:  food_items.ids,
        user_role_ids:  user_roles.ids,
        supplier_ids:   suppliers.ids
      )
  end
end