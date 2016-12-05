class CostGraph 
  attr_accessor :restaurant
  attr_accessor :kitchen

  def initialize(restaurant, kitchen: nil)
    @restaurant = restaurant
    @kitchen = kitchen
  end

  def result
    res = {}
    items =  OrderItem.joins(:order)
                      .includes(:category, :order)
                      .where(orders: { status: :delivered })
                      .order('orders.delivered_at asc')

    items = items.where(restaurant_id: restaurant.id) if restaurant.present?
    items = items.where(kitchen_id: kitchen.id) if kitchen.present?

    items.each do |item|
      month = item.order.delivered_at.beginning_of_month
      res[month] ||= {}
      res[month][item.category&.name] ||= 0
      res[month][item.category&.name] = item.total_price.exchange_to(restaurant.currency).to_f
    end
    res.to_json
  end
end