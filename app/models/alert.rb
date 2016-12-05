class Alert < ActiveRecord::Base
  include ApplicationHelper
  extend Enumerize
  self.inheritance_column = :_type_disabled

  belongs_to :alertable, polymorphic: true

  enumerize :type, in: [:pending_order, :accepted_order, :cancelled_order, :low_quantity, :incoming_delivery]

  after_save :cache_redis

  def self.accessible_by(current_ability, restaurant: nil, kitchen: nil)
    inventories = Inventory.accessible_by(current_ability)
    orders = Order.accessible_by(current_ability)

    if(restaurant.present?)
      inventories = inventories.where(restaurant: restaurant)
      orders     = orders.where(restaurant: restaurant)
    end

    if(kitchen.present?)
      inventories = inventories.where(kitchen: kitchen)
      orders     = orders.where(kitchen: kitchen)
    end

    where("
          (alerts.alertable_type='Inventory' AND alerts.alertable_id IN (:inventory_ids)) OR
          (alerts.alertable_type='Order' AND alerts.alertable_id IN (:order_ids))
        ", inventory_ids: inventories.ids , order_ids: orders.ids)
  end

  def title
    case type 
      when 'pending_order'
        "#{alertable.name} has not been received yet"   
      when 'accepted_order'
        "#{alertable.name} has been accepted" 
      when 'declined_order'
        "#{alertable.name} has been declined" 
      when 'low_quantity'
        "#{alertable.name} in the kitchen is running low"
      when 'cancelled_order'
        "#{alertable.name} has been cancelled"
      when 'incoming_delivery'
        "#{alertable.name} was requested to delivery at #{format_datetime(alertable.request_for_delivery_at)}"
    end
  end

  def kitchen
    alertable.kitchen
  end

  protected 
  def cache_redis
    kitchen.set_redis(:alert_updated_at, Time.zone.now)
  end
end