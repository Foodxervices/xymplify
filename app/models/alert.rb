class Alert < ActiveRecord::Base
  belongs_to :alertable, polymorphic: true
  
  validates :title, presence: true

  def self.accessible_by(current_ability)
    food_item_ids = FoodItem.accessible_by(current_ability).ids 
    order_ids = Order.accessible_by(current_ability).ids

    where("
          (alerts.alertable_type='FoodItem' AND alerts.alertable_id IN (:food_item_ids)) OR
          (alerts.alertable_type='Order' AND alerts.alertable_id IN (:order_ids))
        ", food_item_ids: food_item_ids, order_ids: order_ids)
  end
end