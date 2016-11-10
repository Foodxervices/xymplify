class AddAmountToOrders < ActiveRecord::Migration
  def change
    add_monetize :orders, :price
    remove_monetize :order_gsts, :amount

    Order.all.includes(:items, items: :food_item).each do |order|
      order.price = order.items.map(&:total_price).inject(0, :+)
      order.save
    end
  end
end
