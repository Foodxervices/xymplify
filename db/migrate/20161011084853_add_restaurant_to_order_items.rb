class AddRestaurantToOrderItems < ActiveRecord::Migration
  def change
    add_reference :order_items, :restaurant, index: true

    OrderItem.all.each do |item|
      item.update_column(:restaurant_id, item.order.restaurant_id)
    end
  end
end
