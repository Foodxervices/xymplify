class CostGraph 
  attr_accessor :restaurant

  def initialize(restaurant)
    @restaurant = restaurant
  end

  def result
    res = {}
    items = restaurant.order_items
                      .joins(:order)
                      .includes(:category, :order)
                      .where(orders: { status: :delivered })
                      .order('orders.delivered_at asc')

    items.each do |item|
      month = item.order.delivered_at.beginning_of_month
      res[month] ||= {}
      res[month][item.category&.name] ||= 0
      res[month][item.category&.name] = item.total_price.exchange_to(restaurant.currency).to_f
    end
    res.to_json
  end
end