class AddDeliveryFieldsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :outlet_name, :string
    add_column :orders, :outlet_address, :string
    add_column :orders, :outlet_phone, :string
    add_column :orders, :request_for_delivery_at, :datetime
    add_column :orders, :delivered_to_kitchen, :boolean, default: true

    Order.all.includes(:kitchen).each do |order|
      kitchen = order.kitchen
      order.update_columns(outlet_name: kitchen.name, outlet_address: kitchen.address, outlet_phone: kitchen.phone, request_for_delivery_at: order.delivered_at)
    end
  end
end
