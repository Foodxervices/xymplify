task :update_alerts => :environment do
  puts "Updating alerts..."
  FoodItem.where('current_quantity <= low_quantity').each do |food_item| 
    food_item.alerts.create(title: "#{food_item.name} in the kitchen is running low")
  end

  Order.where(status: :placed).where('placed_at <= ?', 7.days.ago).each do |order|
    order.alerts.create(title: "#{order.name} has not been received yet")
  end
  puts "done."
end