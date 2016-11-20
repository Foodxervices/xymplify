task :update_alerts => :environment do
  puts "Updating alerts..."
  FoodItem.where('current_quantity <= low_quantity').each do |food_item| 
    food_item.alerts.create(type: :low_quantity)
  end

  Order.where(status: :placed).where('placed_at <= ?', 7.days.ago).each do |order|
    order.alerts.create(type: :pending_order)
  end

  Order.where(status: [:placed, :accepted]).where(request_for_delivery_at: [1.day.ago..Time.zone.now]).each do |order|
    order.alerts.create(type: :incoming_delivery)
  end
  puts "done."
end

task :check_cut_off_timing => :environment do 
  puts "Checking cut off timing..."
  Supplier.where('cut_off_timing > 0').includes(:orders).each do |supplier|
    supplier.orders.each do |order|
      if order.status.placed? && order.placed_at < supplier.cut_off_timing.days.ago
        ActiveRecord::Base.transaction do
          order.status = :cancelled
          if order.save
            order.alerts.create(type: :cancelled_order)
            Premailer::Rails::Hook.perform(OrderMailer.notify_supplier_after_cancelled(order)).deliver_later
          end
        end
      end
    end
  end
  puts "done."
end