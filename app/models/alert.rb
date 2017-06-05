class Alert < ActiveRecord::Base
  include OrderHelper
  extend Enumerize
  self.inheritance_column = :_type_disabled

  belongs_to :alertable, polymorphic: true

  enumerize :type, in: [:pending_order, :pending_for_approval, :approved_order, :rejected_order, :accepted_order, :cancelled_order, :low_quantity, :incoming_delivery]

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
        "#{alertable.long_name} has not been received yet"
      when 'pending_for_approval'
        "#{alertable.long_name} is pending for approval"
      when 'approved_order'
        "#{alertable.long_name} has been approved"
      when 'rejected_order'
        "#{alertable.long_name} has been rejected"
      when 'accepted_order'
        "#{alertable.long_name} has been accepted"
      when 'declined_order'
        "#{alertable.long_name} has been declined"
      when 'low_quantity'
        "#{alertable.name} in the kitchen is running low"
      when 'cancelled_order'
        "#{alertable.long_name} has been cancelled"
      when 'incoming_delivery'
        "#{alertable.long_name} was requested to delivery at #{date_of_delivery(alertable)}"
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