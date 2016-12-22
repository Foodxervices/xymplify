class FrequentlyOrderedWorker
  include Sidekiq::Worker

  def perform(order_id)
    order = Order.find(order_id)
    
    order.items.includes(:food_item).each do |item|
      item.food_item.increment!(:ordered_count)
    end
  end
end