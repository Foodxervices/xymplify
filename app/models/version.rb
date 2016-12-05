class Version < PaperTrail::Version
  belongs_to :user, foreign_key: :whodunnit
  belongs_to :order_gst, -> { includes(:versions).where(versions: { item_type: 'OrderGst' }) }, foreign_key: :item_id
  belongs_to :order_item, -> { includes(:versions).where(versions: { item_type: 'OrderItem' }) }, foreign_key: :item_id
  belongs_to :inventory, -> { includes(:versions).where(versions: { item_type: 'Inventory' }) }, foreign_key: :item_id


  def self.by_restaurant(restaurant_id)
    where("
          (versions.item_type='Restaurant' AND versions.item_id=:restaurant_id) OR
          (versions.object_changes ILIKE '%restaurant_id:\n- \n- :restaurant_id%') OR
          (versions.object ILIKE '%restaurant_id: :restaurant_id%')
        ", restaurant_id: restaurant_id)
    .order(created_at: :desc)
  end

  def self.by_kitchen(kitchen_id)
    where("
          (versions.item_type='Kitchen' AND versions.item_id=:kitchen_id) OR
          (versions.object_changes ILIKE '%kitchen_id:\n- \n- :kitchen_id%') OR
          (versions.object ILIKE '%kitchen_id: :kitchen_id%')
        ", kitchen_id: kitchen_id)
    .order(created_at: :desc)
  end
end