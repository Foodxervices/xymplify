class RenameRequestForDeliveryStartAt < ActiveRecord::Migration
  def change
    add_column :orders, :request_delivery_date, :date 
    add_column :orders, :start_time, :string
    add_column :orders, :end_time, :string

    remove_column :orders, :request_for_delivery_start_at
    remove_column :orders, :request_for_delivery_end_at

    Order.all.each do |order|
      order.request_delivery_date = 1.day.from_now
      order.start_time = '8:00 AM'
      order.end_time = '5:00 PM'
      order.save
    end
  end
end
