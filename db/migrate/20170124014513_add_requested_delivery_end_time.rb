class AddRequestedDeliveryEndTime < ActiveRecord::Migration
  def change
    rename_column :orders, :request_for_delivery_at, :request_for_delivery_start_at
    add_column :orders, :request_for_delivery_end_at, :datetime
    add_index :orders, :request_for_delivery_end_at

    Order.all.each do |order|
      if order.request_for_delivery_start_at.present?
        order.update_column(:request_for_delivery_end_at, order.request_for_delivery_start_at + 1.hour)
      end
    end
  end
end
