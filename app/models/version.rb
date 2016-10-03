class Version < PaperTrail::Version
  default_scope { order(created_at: :desc) }

  def user
    User.find_by_id(whodunnit) if whodunnit
  end  

  def self.by_restaurant(restaurant_id)
    where("
          (versions.item_type='Restaurant' AND versions.item_id=:restaurant_id) OR
          (versions.object_changes ILIKE '%restaurant_id:\n- \n- :restaurant_id%') OR
          (versions.object ILIKE '%restaurant_id: :restaurant_id%')
        ", restaurant_id: restaurant_id)
  end
end