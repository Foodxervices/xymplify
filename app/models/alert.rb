class Alert < ActiveRecord::Base
  belongs_to :alertable, polymorphic: true
  
  validates :title, presence: true

  def self.accessible_by(current_ability, restaurant: nil)
    food_items = FoodItem.accessible_by(current_ability)
    orders = Order.accessible_by(current_ability)

    if(restaurant.present?)
      food_items = food_items.where(restaurant: restaurant)
      orders     = orders.where(restaurant: restaurant)
    end

    where("
          (alerts.alertable_type='FoodItem' AND alerts.alertable_id IN (:food_item_ids)) OR
          (alerts.alertable_type='Order' AND alerts.alertable_id IN (:order_ids))
        ", food_item_ids: food_items.ids , order_ids: orders.ids)
  end
end