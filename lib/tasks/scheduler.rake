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

task :random_group => :environment do 
  FoodItem.all.includes(:restaurant).each do |food_item|
    random_supplier = food_item.restaurant.suppliers.sample
    random_category = Category.all.sample
    food_item.update_attributes(
        category_id: random_category.id, 
        tag_list: "#{random_category.name} #{rand(1..4)}",
        supplier_id: random_supplier.id,
        unit_price_currency: random_supplier.currency
      )
  end
end