class CostGraph 
  attr_accessor :restaurant

  def initialize(restaurant)
    @restaurant = restaurant
  end

  def result
    res = {}
    items = restaurant.order_items
                      .joins(:order)
                      .includes(:tags, :order)
                      .where(orders: { status: :delivered })
                      .order('orders.delivered_at asc')
    items.each do |item|
      item.tags.each do |tag|
        month = item.order.delivered_at.beginning_of_month
        res[month] ||= {}
        res[month][tag.name] ||= 0
        res[month][tag.name] += item.total_price.exchange_to(restaurant.currency).to_f
      end
    end
    res.to_json
  end
end