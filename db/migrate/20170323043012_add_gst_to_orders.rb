class AddGstToOrders < ActiveRecord::Migration
  def change
    add_monetize :orders, :gst

    Order.all.each do |order|
      order.cache_price
    end
  end
end
