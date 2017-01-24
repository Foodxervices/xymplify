task :update_alerts => :environment do
  puts "Updating alerts..."
  Inventory.joins(:food_item).where('inventories.current_quantity <= food_items.low_quantity').each do |inventory|
    inventory.alerts.create(type: :low_quantity)
  end

  Order.where(status: :placed).where('placed_at <= ?', 7.days.ago).each do |order|
    order.alerts.create(type: :pending_order)
  end
  puts "done."
end

task :alert_incoming_deliveries => :environment do
  puts "Checking incoming deliveries..."
  Order.where(status: [:placed, :accepted]).where(request_for_delivery_start_at: [1.day.from_now.beginning_of_day..1.day.from_now.end_of_day]).each do |order|
    order.alerts.create(type: :incoming_delivery)
  end
  puts "done."
end

task :empty_trash => :environment do
  puts "Removing..."
  Attachment.where(food_item_id: nil).where('updated_at < ?', 1.hour.ago).destroy_all
  puts "done."
end